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
	TeamName  string    `json:"team_name"`
	Round     int       `json:"round"`
	EnteredAt time.Time `json:"entered_at"`
}

func (app *Application) Login(c echo.Context) error {
	team := c.FormValue("team")
	key := c.FormValue("key")
	var team_id uuid.UUID
	err := app.DB.Pool.QueryRow(context.Background(), "SELECT user_id FROM USERS where team_name=$1 and key=$2", team, key).Scan(&team_id)
	if err != nil {
		out := JSONError{Error: err.Error(), Message: "Not signing you in"}
		return c.JSON(http.StatusUnauthorized, out)
	}
	expiry := time.Now().Add(time.Hour * 1000)
	claims := &JwtCustomClaims{team, team_id.String(), jwt.RegisteredClaims{ExpiresAt: jwt.NewNumericDate(expiry)}}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	t, err := token.SignedString([]byte("meow"))
	if err != nil {
		return err
	}
	cookie := new(http.Cookie)
	cookie.Name = "JWT"
	cookie.Value = t
	cookie.Expires = time.Now().Add(time.Hour * 1000)
	cookie.HttpOnly = true
	c.SetCookie(cookie)
	return c.JSON(http.StatusOK, echo.Map{"token": t})

}

func (app *Application) Questions(c echo.Context) error {
	loc := c.Get("location").(string)
	round_num := c.Get("round_num").(int)
	fmt.Println(round_num)
	loc_id, _ := strconv.Atoi(loc)
	user_id := c.Get("user_id").(uuid.UUID)
	game, err := game.Play(app.DB, loc_id, user_id)
	if err != nil {
		return c.JSON(http.StatusOK, struct{ Name string }{Name: "jhol bhidu"})
	}
	return c.JSON(http.StatusOK, game)
}

func (app *Application) LeaderBoard(c echo.Context) error {
	rows, err := app.DB.Pool.Query(context.Background(), "select team_name, round_num, entered_at from user_rounds ur natural join users y order by round_num desc, entered_at asc")
	if err != nil {
		c.String(http.StatusOK, "Jhol bhidu")
	}
	currentLeaderBoard := LeaderBoard{LeaderBoard: make([]*LeaderBoardEntry, 0)}
	for {
		if !rows.Next() {
			break
		}
		currentLeaderBoardEntry := LeaderBoardEntry{}
		rows.Scan(&currentLeaderBoardEntry.TeamName, &currentLeaderBoardEntry.Round, &currentLeaderBoardEntry.EnteredAt)
		currentLeaderBoard.LeaderBoard = append(currentLeaderBoard.LeaderBoard, &currentLeaderBoardEntry)
	}
	return c.JSON(http.StatusOK, currentLeaderBoard)

}

// func (app *Application) QuestionAnswers(c echo.Context) error {

// }
