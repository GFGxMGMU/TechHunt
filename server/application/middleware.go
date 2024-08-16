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
			return c.Redirect(http.StatusTemporaryRedirect, "/")
		}
		token := cookie.Value
		c.Request().Header.Set("Authorization", "Bearer "+token)
		return next(c)
	}
}

func (app *Application) LocationMiddleware(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		fmt.Println("hohoho")
		code := c.QueryParam("code")
		user := c.Get("user")
		if user == nil {
			return c.Redirect(http.StatusOK, "Sign in")
		}
		userToken := user.(*jwt.Token)
		claims := userToken.Claims.(*JwtCustomClaims)
		user_id, err := uuid.Parse((claims.TeamId))
		if err != nil {
			fmt.Println(err)
			return c.String(http.StatusInternalServerError, "Working on this error")
		}
		c.Set("user_id", user_id)
		var loc_id string
		var round_num int
		query := `select loc_id, round_num from locations natural join access_codes natural join location_users natural join user where code=$1 and user_id=$2`
		err = app.DB.Pool.QueryRow(context.Background(), query, code, user_id).Scan(&loc_id, &round_num)
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
