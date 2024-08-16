package game

import (
	"context"
	"fmt"
	DB "gfghunt/db"
	"time"

	"github.com/google/uuid"
)

type Game struct {
	Questions []*Question `json:"questions"`
	EndTime   time.Time   `json:"endtime"`
	Submitted bool        `json:"submitted"`
}

type Question struct {
	Question string  `json:"question"`
	Option1  *Option `json:"option1"`
	Option2  *Option `json:"option2"`
	Option3  *Option `json:"option3"`
	Option4  *Option `json:"option4"`
	Correct  *Option `json:"-"`
}
type Option struct {
	Option string `json:"option"`
}

var onGoingGames map[uuid.UUID]*Game = make(map[uuid.UUID]*Game)

func Play(db *DB.DB, loc_id int, user_id uuid.UUID) (*Game, error) {
	current_Game, ok := onGoingGames[user_id]
	if !ok || current_Game.Submitted || current_Game.EndTime.Before(time.Now()) {
		current_Game, err := NewGame(db, loc_id)
		if err != nil {
			return nil, err
		}
		onGoingGames[user_id] = current_Game
		return current_Game, nil
	}
	return current_Game, nil

}
func NewGame(db *DB.DB, loc_id int) (*Game, error) {
	query := `select question, option1, option2, option3, option4, correct from questions where loc_id=$1 order by gen_random_uuid() limit 5`
	rows, err := db.Pool.Query(context.Background(), query, loc_id)
	if err != nil {
		fmt.Println(err)
		return nil, err
	}
	questions := make([]*Question, 0)
	for {
		if !rows.Next() {
			fmt.Println("hfg", loc_id)
			break
		}
		option1 := new(Option)
		option2 := new(Option)
		option3 := new(Option)
		option4 := new(Option)
		var correct int
		question := Question{Option1: option1, Option2: option2, Option3: option3, Option4: option4}
		rows.Scan(&question.Question, &option1.Option, &option2.Option, &option3.Option, &option4.Option, &correct)
		switch correct {
		case 1:
			question.Correct = option1
		case 2:
			question.Correct = option2
		case 3:
			question.Correct = option3
		case 4:
			question.Correct = option4
		}
		questions = append(questions, &question)
	}
	return &Game{Questions: questions, EndTime: time.Now().Add(5 * time.Second)}, nil
}
