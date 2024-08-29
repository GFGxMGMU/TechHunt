package application

import (
	"context"
	"fmt"
	"gfghunt/game"
	"net/http"
	"strconv"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
)

type JSONError struct {
	Error   string `json:"error"`
	Message string `json:"message"`
}
type Message struct {
	Message  string
	LinkText string
	Link     string
}
type LeaderBoard struct {
	LeaderBoard []*LeaderBoardEntry `json:"leaderboard"`
	WinnerId    uuid.UUID
	WinnerName  string
	IsWinner    bool
}
type LeaderBoardEntry struct {
	TeamName  string `json:"team_name"`
	RoundNum  int    `json:"round"`
	EnteredAt string `json:"entered_at"`
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
	return c.Render(http.StatusOK, "message", BaseTemplateConfig(c, message))

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
	return c.Render(http.StatusOK, "dashboard", BaseTemplateConfig(c, out))
}

func (app *Application) Questions(c echo.Context) error {
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
	rows, err := app.DB.Pool.Query(context.Background(), "select team_name, round_num, entered_at from user_rounds ur natural join users y where ur.submitted=false order by round_num desc, entered_at asc")
	currentLeaderBoard := LeaderBoard{LeaderBoard: make([]*LeaderBoardEntry, 0)}
	for {
		if !rows.Next() {
			break
		}
		currentLeaderBoardEntry := LeaderBoardEntry{}
		var enteredAt time.Time
		rows.Scan(&currentLeaderBoardEntry.TeamName, &currentLeaderBoardEntry.RoundNum, &enteredAt)
		currentLeaderBoardEntry.EnteredAt = enteredAt.Format(time.RFC822)
		currentLeaderBoard.LeaderBoard = append(currentLeaderBoard.LeaderBoard, &currentLeaderBoardEntry)
	}
	if err != nil {
		message := Message{
			Message:  "Problem viewing the leaderboard",
			LinkText: "Retry",
			Link:     "/",
		}
		fmt.Println(err.Error())
		c.Render(http.StatusInternalServerError, "message", BaseTemplateConfig(c, message))
	}
	err = app.DB.Pool.QueryRow(context.Background(), "select user_id, team_name from winner natural join users").Scan(&currentLeaderBoard.WinnerId, &currentLeaderBoard.WinnerName)
	if err == nil {
		currentLeaderBoard.IsWinner = true
	}
	return c.Render(http.StatusOK, "leaderboard", BaseTemplateConfig(c, currentLeaderBoard))

}

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
			Link:     "javascript:history.back()",
		}
		return c.Render(http.StatusUnauthorized, "message", BaseTemplateConfig(c, message))
	}
	if currentGame.EndTime.Before(time.Now()) {
		message := Message{
			Message:  "Time out! Please try again :)",
			LinkText: "Go back",
			Link:     "javascript:history.back()",
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
				Link:     "javascript:history.back()",
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
				Link:     "javascript:history.back()",
			}
			return c.Render(http.StatusOK, "message", BaseTemplateConfig(c, message))
		}
		message := Message{
			Message:  "Right answers! The new hint is at your dashboard. You may proceed!",
			Link:     "Go to the dashboard for the next hint!",
			LinkText: "/hunt/dashboard",
		}
		return c.Render(http.StatusOK, "messageGreen", BaseTemplateConfig(c, message))
	}
	message := Message{
		Message:  `A few answers are wrong! Retry, or as Swami Vivekananda said, "Arise, awake, and stop not till the goal is reached!"`,
		LinkText: "Go back",
		Link:     "javascript:history.back()",
	}
	return c.Render(http.StatusOK, "message", BaseTemplateConfig(c, message))
}
