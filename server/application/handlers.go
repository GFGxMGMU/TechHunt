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

// func (app *Application) QuestionAnswers(c echo.Context) error {

// }
