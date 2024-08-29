package application

import (
	"context"
	"fmt"
	"net/http"

	"github.com/google/uuid"
	_ "github.com/labstack/echo-jwt/v4"
	"github.com/labstack/echo/v4"
)

func (app *Application) HuntMiddleware(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		logged_in := c.Get("logged_in").(bool)
		if !logged_in {
			message := Message{
				Message:  "Please login if you want to play!",
				LinkText: "Go to the login page",
				Link:     "/login",
			}
			return c.Render(http.StatusForbidden, "message", BaseTemplateConfig(c, message))
		}
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
			message := Message{
				Message:  "Location forbidden. You don't have access to this location, at least at this stage.",
				LinkText: "Go to the dashboard",
				Link:     "/hunt/dashboard",
			}
			return c.Render(http.StatusForbidden, "message", BaseTemplateConfig(c, message))
		}
		fmt.Println(loc_id)
		c.Set("location", loc_id)
		c.Set("round_num", round_num)
		return next(c)
	}
}
