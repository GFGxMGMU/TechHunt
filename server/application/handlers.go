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

type LeaderBoard struct {
	LeaderBoard []*LeaderBoardEntry `json:"leaderboard"`
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

func (app *Application) LoginView(c echo.Context) error {
	return c.Render(http.StatusOK, "login", nil)
}
func (app *Application) Login(c echo.Context) error {
	team := c.FormValue("team")
	key := c.FormValue("key")
	var team_id uuid.UUID
	err := app.DB.Pool.QueryRow(context.Background(), "SELECT user_id FROM USERS where team_name=$1 and key=$2", team, key).Scan(&team_id)
	if err != nil {
		return c.Render(http.StatusUnauthorized, "message", "Wrong credentials")
	}
	expiry := time.Now().Add(time.Hour * 1000)
	claims := &JwtCustomClaims{team, team_id.String(), jwt.RegisteredClaims{ExpiresAt: jwt.NewNumericDate(expiry)}}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	t, err := token.SignedString([]byte("meow"))
	if err != nil {
		return c.Render(http.StatusInternalServerError, "message", "There was an error signing you in")
	}
	cookie := new(http.Cookie)
	cookie.Name = "JWT"
	cookie.Value = t
	cookie.Expires = time.Now().Add(time.Hour * 1000)
	cookie.HttpOnly = true
	c.SetCookie(cookie)
	return c.Render(http.StatusOK, "message", "Go to dashboard")

}

func (app *Application) DashboardView(c echo.Context) error {
	user_id := c.Get("user_id").(uuid.UUID)
	query := `select round_num, team_name, hint from users natural join user_rounds natural join location_users natural join hints where user_id=$1`
	out := Dashboard{}
	err := app.DB.Pool.QueryRow(context.Background(), query, user_id).Scan(&out.RoundNum, &out.TeamName, &out.Hint)
	if err != nil {
		fmt.Println(err)
		return c.Render(http.StatusOK, "message", "There was a problem viewing the dashboard")
	}
	fmt.Println(out)
	return c.Render(http.StatusOK, "dashboard", out)
}

func (app *Application) Questions(c echo.Context) error {
	loc := c.Get("location").(string)
	round_num := c.Get("round_num").(int)
	fmt.Println(round_num)
	loc_id, _ := strconv.Atoi(loc)
	user_id := c.Get("user_id").(uuid.UUID)
	game, err := game.Play(app.DB, loc_id, user_id)
	if err != nil {
		return c.Render(http.StatusInternalServerError, "message", err.Error())
	}
	return c.Render(http.StatusOK, "questions", game)
}

func (app *Application) LeaderBoardView(c echo.Context) error {
	rows, err := app.DB.Pool.Query(context.Background(), "select team_name, round_num, entered_at from user_rounds ur natural join users y order by round_num desc, entered_at asc")
	if err != nil {
		c.Render(http.StatusOK, "message", err.Error())
	}
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
	return c.Render(http.StatusOK, "leaderboard", currentLeaderBoard.LeaderBoard)

}

func (app *Application) QuestionAnswers(c echo.Context) error {
	user_id := c.Get("user_id").(uuid.UUID)
	currentGame, err := game.GetGame(user_id)
	if err != nil {
		return c.Render(http.StatusNotFound, "message", "Game not found. Try scanning the QR code again.")
	}
	correctCount := 0
	if currentGame.Submitted {
		return c.Render(http.StatusUnauthorized, "message", "This instance of the quiz already submitted")
	}
	if currentGame.EndTime.Before(time.Now()) {
		return c.Render(http.StatusUnauthorized, "message", "Time out! Try again.")
	}
	currentGame.Submitted = true
	for _, question := range currentGame.Questions {
		correct := question.Correct
		correctOption := fmt.Sprintf("option%d", correct)
		que_id := question.QuestionId
		answer := c.FormValue(que_id.String())
		if answer == "" {
			return c.Render(http.StatusNotAcceptable, "message", "There was an error submitting. You probably ran out of time")
		}
		if answer == correctOption {
			correctCount++
		}
	}
	if correctCount == 5 {
		// Advance the user to the next round
		err = app.Advance(user_id, currentGame.RoundNum)
		if err != nil {
			return c.Render(http.StatusOK, "message", err.Error())
		}
		return c.Render(http.StatusOK, "messageGreen", "Right answers! The new hint is at your dashboard. You may proceed!")
	}
	return c.Render(http.StatusOK, "message", "A few answers are wrong! Retry.")
}
