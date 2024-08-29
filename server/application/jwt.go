package application

import (
	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
	echojwt "github.com/labstack/echo-jwt/v4"
	"github.com/labstack/echo/v4"
)

type JwtCustomClaims struct {
	TeamName string `json:"team_name"`
	TeamId   string `json:"team_id"`
	jwt.RegisteredClaims
}

func (app *Application) ConfigJWT() *echojwt.Config {
	return &echojwt.Config{
		TokenLookup: "cookie:JWT",
		SuccessHandler: func(c echo.Context) {
			c.Set("logged_in", true)
			user := c.Get("user")
			userToken := user.(*jwt.Token)
			claims := userToken.Claims.(*JwtCustomClaims)
			user_id, _ := uuid.Parse((claims.TeamId))
			c.Set("user_id", user_id)
			c.Set("user_name", claims.TeamName)
		},
		ContinueOnIgnoredError: true,
		ErrorHandler: func(c echo.Context, err error) error {
			c.Set("logged_in", false)
			c.Set("user_name", "")
			return nil
		},
		NewClaimsFunc: func(c echo.Context) jwt.Claims {
			return new(JwtCustomClaims)
		},
		SigningKey: []byte("meow"),
	}
}
