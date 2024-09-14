package application

import (
	"context"
	"errors"
	"fmt"
	"gfghunt/game"
	"net/http"
	"strconv"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
)

type TooLateError struct {
	Message string
}
type JSONError struct {
	Error   string `json:"error"`
	Message string `json:"message"`
}
type Message struct {
	Message  string
	LinkText string
	Link     string
}

type Dashboard struct {
	TeamName string
	RoundNum int
	Hint     string
}

type TemplateData struct {
	IsLoggedIn bool
	TeamName   string
	Data       interface{}
}

func (e TooLateError) Error() string {
	return e.Message
}

func BaseTemplateConfig(c echo.Context, data interface{}) *TemplateData {
	return &TemplateData{
		IsLoggedIn: c.Get("logged_in").(bool),
		TeamName:   c.Get("user_name").(string),
		Data:       &data,
	}
}

func (app *Application) LoginView(c echo.Context) error {

	logged_in := c.Get("logged_in").(bool)
	if logged_in {
		message := Message{
			Message:  "You are already logged in. Just logout if you wanna use different credentials",
			LinkText: "Meanwhile, enjoy the leaderboard",
			Link:     "/",
		}
		return c.Render(http.StatusOK, "message", BaseTemplateConfig(c, message))
	}
	return c.Render(http.StatusOK, "login", BaseTemplateConfig(c, nil))
}
func (app *Application) Login(c echo.Context) error {
	team := c.FormValue("team")
	key := c.FormValue("key")
	var team_id uuid.UUID
	err := app.DB.Pool.QueryRow(context.Background(), "SELECT user_id FROM USERS where team_name=$1 and key=$2", team, key).Scan(&team_id)
	if err != nil {
		message := &Message{
			Message:  "Wrong Credentials",
			LinkText: "Go to the login page",
			Link:     "/login",
		}
		return c.Render(http.StatusUnauthorized, "message", BaseTemplateConfig(c, message))
	}
	expiry := time.Now().Add(time.Hour * 100 * 24)
	claims := &JwtCustomClaims{team, team_id.String(), jwt.RegisteredClaims{ExpiresAt: jwt.NewNumericDate(expiry)}}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	t, err := token.SignedString([]byte("meow"))
	if err != nil {
		message := &Message{
			Message:  "Couldn't sign you in. Contact the team.",
			LinkText: "Go to the login page",
			Link:     "/login",
		}
		return c.Render(http.StatusInternalServerError, "message", BaseTemplateConfig(c, message))
	}
	cookie := new(http.Cookie)
	cookie.Name = "JWT"
	cookie.Value = t
	cookie.Expires = expiry
	cookie.HttpOnly = true
	c.SetCookie(cookie)
	message := Message{
		Message:  "Logged in successfully.",
		LinkText: "Go to the dashboard",
		Link:     "/hunt/dashboard",
	}
	return c.Render(http.StatusOK, "messageGreen", BaseTemplateConfig(c, message))

}

func (app *Application) DashboardView(c echo.Context) error {
	user_id := c.Get("user_id").(uuid.UUID)
	query := `select round_num, team_name, hint from users natural join user_rounds natural join location_users natural join hints where user_id=$1 and submitted=false`
	out := Dashboard{}
	err := app.DB.Pool.QueryRow(context.Background(), query, user_id).Scan(&out.RoundNum, &out.TeamName, &out.Hint)
	if err != nil {
		fmt.Println(err)
		message := Message{
			Message:  "There was a problem viewing the dashboard. Try calling Kunal.",
			LinkText: "Go to the login page",
			Link:     "/login",
		}
		return c.Render(http.StatusInternalServerError, "message", BaseTemplateConfig(c, message))
	}
	if out.RoundNum == 0 {
		if !app.Start {
			message := Message{
				Message:  "Game not eshtarted yet. Wait for the admin to eshtart. Keep refreshing. Best of luck.",
				LinkText: "Go to the dashboard",
				Link:     "/hunt/dashboard",
			}
			return c.Render(http.StatusNotFound, "message", BaseTemplateConfig(c, message))
		}
		if time.Now().Before(app.StartTime) {
			message := Message{
				Message:  fmt.Sprintf("Game starting in %v seconds. Refresh then", int(time.Until(app.StartTime).Seconds())),
				LinkText: "Go to the dashboard",
				Link:     "/hunt/dashboard",
			}
			return c.Render(http.StatusNotFound, "message", BaseTemplateConfig(c, message))
		}
		game, err := game.Play(app.DB, -1, user_id)

		if err != nil {
			message := Message{Message: "Error getting questions",
				LinkText: "Go to the login page",
				Link:     "/login",
			}
			return c.Render(http.StatusInternalServerError, "message", BaseTemplateConfig(c, message))
		}
		return c.Render(http.StatusOK, "questions0", BaseTemplateConfig(c, game))
	}
	return c.Render(http.StatusOK, "dashboard", BaseTemplateConfig(c, out))
}

func (app *Application) Questions(c echo.Context) error {
	fmt.Println(app.Start)
	loc := c.Get("location").(string)
	round_num := c.Get("round_num").(int)
	fmt.Println(round_num)
	loc_id, _ := strconv.Atoi(loc)
	user_id := c.Get("user_id").(uuid.UUID)
	game, err := game.Play(app.DB, loc_id, user_id)
	accessCode := c.QueryParam("code")
	game.AccessCode = accessCode
	if err != nil {
		fmt.Println("Error while processing user questions", "loc", loc, "round_num", round_num, "user_id", user_id, err.Error())
		message := Message{Message: "Error getting questions",
			LinkText: "Go to the login page",
			Link:     "/login",
		}
		return c.Render(http.StatusInternalServerError, "message", BaseTemplateConfig(c, message))
	}
	return c.Render(http.StatusOK, "questions", BaseTemplateConfig(c, game))
}

func (app *Application) LeaderBoardView(c echo.Context) error {
	currentLeaderBoard := app.getCurrentLeaderBoard()
	if currentLeaderBoard.err != nil {
		message := Message{
			Message:  "Problem viewing the leaderboard",
			LinkText: "Retry",
			Link:     "/",
		}
		c.Render(http.StatusInternalServerError, "message", BaseTemplateConfig(c, message))

	}
	return c.Render(http.StatusOK, "leaderboard", BaseTemplateConfig(c, *currentLeaderBoard))

}

// Danger ahead
// ----------------------------------------------------------------------------------------------------------

func (app *Application) Begin(c echo.Context) error {
	user_id := c.Get("user_id").(uuid.UUID)
	currentGame, err := game.GetGame(user_id)
	if err != nil {
		message := Message{
			Message:  "Game not found. Try scanning the QR code again.",
			LinkText: "Go to the dashboard",
			Link:     "/hunt/dashboard",
		}
		return c.Render(http.StatusNotFound, "message", BaseTemplateConfig(c, message))
	}
	correctCount := 0
	if currentGame.RoundNum != 0 {
		message := Message{
			Message:  "No cheating!",
			LinkText: "Go back",
			Link:     "/hunt/dashboard",
		}
		return c.Render(http.StatusUnauthorized, "message", BaseTemplateConfig(c, message))
	}
	if currentGame.Submitted {
		message := Message{
			Message:  "This instance of the quiz already submitted",
			LinkText: "Go back",
			Link:     "/hunt/dashboard",
		}
		return c.Render(http.StatusUnauthorized, "message", BaseTemplateConfig(c, message))
	}
	if currentGame.EndTime.Before(time.Now()) {
		message := Message{
			Message:  "Time out! Please try again :)",
			LinkText: "Go back",
			Link:     "/hunt/dashboard",
		}
		return c.Render(http.StatusUnauthorized, "message", BaseTemplateConfig(c, message))
	}
	currentGame.Submitted = true
	for _, question := range currentGame.Questions {
		correct := question.Correct
		correctOption := fmt.Sprintf("option%d", correct)
		que_id := question.QuestionId
		answer := c.FormValue(que_id.String())
		if answer == "" {
			message := Message{
				Message:  "There was an error submitting. You probably ran out of time",
				LinkText: "Go back",
				Link:     "/hunt/dashboard",
			}
			return c.Render(http.StatusNotAcceptable, "message", BaseTemplateConfig(c, message))
		}
		if answer == correctOption {
			correctCount++
		}
	}
	if correctCount == 5 {
		// Advance the user to the next round
		err = app.Advance(user_id, currentGame.RoundNum, currentGame.LocationId)
		if err != nil {
			fmt.Println(err.Error(), user_id)
			message := Message{
				Message:  "There was an error submitting. Try again :)",
				LinkText: "Go back",
				Link:     "/hunt/dashboard",
			}
			if errors.As(err, &TooLateError{}) {
				message.Message = err.Error()
			}
			return c.Render(http.StatusOK, "message", BaseTemplateConfig(c, message))
		}
		message := Message{
			Message:  "Right answers! The new hint is at your dashboard. You may proceed!",
			LinkText: "Go to the dashboard for the next hint!",
			Link:     "/hunt/dashboard",
		}
		return c.Render(http.StatusOK, "messageGreen", BaseTemplateConfig(c, message))
	}
	message := Message{
		Message:  `A few answers are wrong! Retry, or as Swami Vivekananda said, "Arise, awake, and stop not till the goal is reached!"`,
		LinkText: "Go back",
		Link:     "/hunt/dashboard",
	}
	return c.Render(http.StatusOK, "message", BaseTemplateConfig(c, message))
}

// ----------------------------------------------------------------------------------------------------------
// Danger over
func (app *Application) QuestionAnswers(c echo.Context) error {
	user_id := c.Get("user_id").(uuid.UUID)
	currentGame, err := game.GetGame(user_id)
	if err != nil {
		message := Message{
			Message:  "Game not found. Try scanning the QR code again.",
			LinkText: "Go to the dashboard",
			Link:     "/hunt/dashboard",
		}
		return c.Render(http.StatusNotFound, "message", BaseTemplateConfig(c, message))
	}
	correctCount := 0
	if currentGame.Submitted {
		message := Message{
			Message:  "This instance of the quiz already submitted",
			LinkText: "Go back",
			Link:     fmt.Sprintf("/hunt/location?code=%v", currentGame.AccessCode),
		}
		return c.Render(http.StatusUnauthorized, "message", BaseTemplateConfig(c, message))
	}
	if currentGame.EndTime.Before(time.Now()) {
		message := Message{
			Message:  "Time out! Please try again :)",
			LinkText: "Go back",
			Link:     fmt.Sprintf("/hunt/location?code=%v", currentGame.AccessCode),
		}
		return c.Render(http.StatusUnauthorized, "message", BaseTemplateConfig(c, message))
	}
	currentGame.Submitted = true
	for _, question := range currentGame.Questions {
		correct := question.Correct
		correctOption := fmt.Sprintf("option%d", correct)
		que_id := question.QuestionId
		answer := c.FormValue(que_id.String())
		if answer == "" {
			message := Message{
				Message:  "There was an error submitting. You probably ran out of time",
				LinkText: "Go back",
				Link:     fmt.Sprintf("/hunt/location?code=%v", currentGame.AccessCode),
			}
			return c.Render(http.StatusNotAcceptable, "message", BaseTemplateConfig(c, message))
		}
		if answer == correctOption {
			correctCount++
		}
	}
	if correctCount == 5 {
		// Advance the user to the next round
		err = app.Advance(user_id, currentGame.RoundNum, currentGame.LocationId)
		if err != nil {
			fmt.Println(err.Error(), user_id)
			message := Message{
				Message:  "There was an error submitting. Try again :)",
				LinkText: "Go back",
				Link:     fmt.Sprintf("/hunt/location?code=%v", currentGame.AccessCode),
			}
			if errors.As(err, &TooLateError{}) {
				message.Message = err.Error()
			}
			return c.Render(http.StatusOK, "message", BaseTemplateConfig(c, message))
		}
		message := Message{
			Message:  "Right answers! The new hint is at your dashboard. You may proceed!",
			LinkText: "Go to the dashboard for the next hint!",
			Link:     "/hunt/dashboard",
		}
		return c.Render(http.StatusOK, "messageGreen", BaseTemplateConfig(c, message))
	}
	message := Message{
		Message:  `A few answers are wrong! Retry, or as Swami Vivekananda said, "Arise, awake, and stop not till the goal is reached!"`,
		LinkText: "Go back",
		Link:     fmt.Sprintf("/hunt/location?code=%v", currentGame.AccessCode),
	}
	return c.Render(http.StatusOK, "message", BaseTemplateConfig(c, message))
}

func (app *Application) LogoutHandler(c echo.Context) error {
	cookie, err := c.Cookie("JWT")
	if err != nil {
		message := Message{
			Message:  "Logged you out!",
			LinkText: "Login",
			Link:     "/login",
		}
		return c.Render(http.StatusOK, "messageGreen", BaseTemplateConfig(c, message))
	}
	cookie.Expires = time.Unix(0, 0)
	c.SetCookie(cookie)
	message := Message{
		Message:  "Logged you out!",
		LinkText: "Login",
		Link:     "/login",
	}
	return c.Render(http.StatusOK, "messageGreen", BaseTemplateConfig(c, message))
}
