package application

import (
	"github.com/golang-jwt/jwt/v5"
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
		NewClaimsFunc: func(c echo.Context) jwt.Claims {
			return new(JwtCustomClaims)
		},
		SigningKey: []byte("meow"),
	}
}
