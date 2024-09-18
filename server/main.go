package main

import (
	"bufio"
	"fmt"
	"gfghunt/application"
	DB "gfghunt/db"
	"gfghunt/templates"
	"net/http"
	"os"
	"strings"
	"time"

	"github.com/golang-jwt/jwt/v5"
	echojwt "github.com/labstack/echo-jwt/v4"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

func main() {
	DBPool := DB.InitDB()
	app := &application.Application{DB: DBPool, Start: false}
	go app.Init()
	go func() {
		reader := bufio.NewReader(os.Stdin)
		for {
			fmt.Println("Enter ESHTART to eshtart", app)
			start, _ := reader.ReadString('\n')
			if strings.TrimSpace(start) == "ESHTART" {
				app.Start = true
				app.StartTime = time.Now().Add(10 * time.Second)
				fmt.Println("Eshtarted!", app)
				break
			}

		}
	}()
	// New echo server object
	e := echo.New()
	e.Static("/assets", "./assets")
	Renderer := &templates.Templates{}
	Renderer.Init()
	e.Renderer = Renderer

	// Group for the actual hunt. Idhar bina login no entry!
	r := e.Group("/hunt")

	jwtConfig := app.ConfigJWT()
	// JWT Middleware.
	// Extracts info like user_id, user_name and login state
	e.Use(echojwt.WithConfig(*jwtConfig))
	r.Use(app.HuntMiddleware)
	r.Use(app.WinnerMiddleware)
	// Locations: This is where the players will come when they scan the qr code
	l := r.Group("/location")
	e.Use(middleware.CORSWithConfig(middleware.CORSConfig{
		AllowOrigins: []string{"*"},
		AllowMethods: []string{http.MethodGet, http.MethodPut, http.MethodPost, http.MethodDelete},
	}))
	l.Use(app.LocationMiddleware)
	r.Use(app.EliminatedMiddleware)
	l.GET("", app.Questions)
	l.POST("", app.QuestionAnswers)
	r.POST("/begin", app.Begin)
	r.GET("/dashboard", app.DashboardView)
	e.GET("/login", app.LoginView)
	e.POST("/login", app.Login)
	r.GET("/yo", func(c echo.Context) error {
		user := c.Get("user").(*jwt.Token)
		claims := user.Claims.(*application.JwtCustomClaims)
		return c.String(http.StatusOK, "meow, "+claims.TeamName)
	})
	e.GET("/", app.LeaderBoardView)
	e.GET("/logout", app.LogoutHandler)
	e.Static("/assets", "assets")
	e.Logger.Fatal(e.Start(":1323"))
}
