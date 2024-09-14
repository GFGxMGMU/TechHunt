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
		var loc_id int
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
		if round_num == 5 {
			app.Advance(user_id, round_num, loc_id)
		}
		fmt.Println(loc_id)
		c.Set("location", fmt.Sprintf("%v", loc_id))
		c.Set("round_num", round_num)
		return next(c)
	}
}

func (app *Application) WinnerMiddleware(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		currentLeaderBoard := app.getCurrentLeaderBoard()
		if currentLeaderBoard.IsWinner {
			message := Message{
				Message:  fmt.Sprintf("Unfortunately, the hunt is over. Congratulations to %v for winning GFG Tech Hunt 2024!", currentLeaderBoard.WinnerName),
				LinkText: "Leaderboard",
				Link:     "/",
			}
			return c.Render(http.StatusForbidden, "messageGreen", BaseTemplateConfig(c, message))
		}
		return next(c)
	}
}
