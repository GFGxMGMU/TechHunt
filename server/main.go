package main

import (
	"gfghunt/application"
	DB "gfghunt/db"
	"gfghunt/templates"
	"net/http"

	"github.com/golang-jwt/jwt/v5"
	echojwt "github.com/labstack/echo-jwt/v4"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

func main() {
	DBPool := DB.InitDB()
	app := &application.Application{DB: DBPool}
	// New echo server object
	e := echo.New()
	e.Static("/assets", "./assets")
	Renderer := &templates.Templates{}
	Renderer.Init()
	e.Renderer = Renderer

	// Group for the actual hunt. Idhar bina login no entry!
	r := e.Group("/hunt")

	jwtConfig := app.ConfigJWT()
	r.Use(app.JwtMiddleWare)
	r.Use(echojwt.WithConfig(*jwtConfig))
	r.Use(app.UserMiddleware)
	// Locations: This is where the players will come when they scan the qr code
	l := r.Group("/location")
	e.Use(middleware.CORSWithConfig(middleware.CORSConfig{
		AllowOrigins: []string{"*"},
		AllowMethods: []string{http.MethodGet, http.MethodPut, http.MethodPost, http.MethodDelete},
	}))
	l.Use(app.LocationMiddleware)
	l.GET("", app.Questions)
	l.POST("", app.QuestionAnswers)
	r.GET("/dashboard", app.DashboardView)
	e.GET("/login", app.LoginView)
	e.POST("/login", app.Login)
	r.GET("/yo", func(c echo.Context) error {
		user := c.Get("user").(*jwt.Token)
		claims := user.Claims.(*application.JwtCustomClaims)
		return c.String(http.StatusOK, "meow, "+claims.TeamName)
	})
	e.GET("/leaderboard", app.LeaderBoardView)
	e.Static("/assets", "assets")
	e.Logger.Fatal(e.Start("localhost:1323"))
}
