package application

import (
	"context"
	"fmt"
	"net/http"

	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
	_ "github.com/labstack/echo-jwt/v4"
	"github.com/labstack/echo/v4"
)

func (app *Application) JwtMiddleWare(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		cookie, err := c.Cookie("JWT")
		if err != nil {
			fmt.Println("meow")
			return c.Render(http.StatusUnauthorized, "message", "You are not logged in.")
		}
		token := cookie.Value
		c.Request().Header.Set("Authorization", "Bearer "+token)
		return next(c)
	}
}

func (app *Application) UserMiddleware(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		user := c.Get("user")
		if user == nil {
			c.Set("logged_in", false)
			return next(c)
		}
		userToken := user.(*jwt.Token)
		claims := userToken.Claims.(*JwtCustomClaims)
		user_id, err := uuid.Parse((claims.TeamId))
		if err != nil {
			fmt.Println(err)
			return c.String(http.StatusInternalServerError, "Working on this error")
		}
		c.Set("logged_in", true)
		c.Set("user_id", user_id)
		c.Set("user_name", claims.TeamName)
		return next(c)
	}
}

func (app *Application) LocationMiddleware(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		fmt.Println("hohoho")
		code := c.QueryParam("code")
		var loc_id string
		var round_num int
		user_id := c.Get("user_id").(uuid.UUID)
		query := `select loc_id, round_num from locations natural join access_codes natural join location_users natural join user where code=$1 and user_id=$2`
		err := app.DB.Pool.QueryRow(context.Background(), query, code, user_id).Scan(&loc_id, &round_num)
		if err != nil {
			fmt.Println("hosdf", err)
			return c.Redirect(http.StatusTemporaryRedirect, "/")
		}
		fmt.Println(loc_id)
		c.Set("location", loc_id)
		c.Set("round_num", round_num)
		return next(c)
	}
}
