package templates

import (
	"errors"
	"fmt"
	"html/template"
	"io"

	"github.com/labstack/echo/v4"
)

type Templates struct {
	Templates map[string]*template.Template
}

func (templates *Templates) Init() {
	templates.Templates = make(map[string]*template.Template)
	templates.Templates["login"] = template.Must(template.ParseFiles("view/base.html", "view/login.html"))
	templates.Templates["message"] = template.Must(template.ParseFiles("view/base.html", "view/message.html"))
	templates.Templates["messageGreen"] = template.Must(template.ParseFiles("view/base.html", "view/message-green.html"))
	templates.Templates["dashboard"] = template.Must(template.ParseFiles("view/base.html", "view/dashboard.html"))
	templates.Templates["leaderboard"] = template.Must(template.ParseFiles("view/base.html", "view/leaderboard.html"))
	templates.Templates["questions"] = template.Must(template.ParseFiles("view/base.html", "view/questions.html"))
}

func (templates *Templates) Render(w io.Writer, name string, data interface{}, c echo.Context) error {
	currentTemplate, ok := templates.Templates[name]
	if !ok {
		err := errors.New("Template " + name + " not found")
		return err
	}
	fmt.Println("Meow")
	return currentTemplate.ExecuteTemplate(w, "base", data)
}
