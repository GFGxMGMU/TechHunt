package game

import (
	"context"
	"errors"
	"fmt"
	DB "gfghunt/db"
	"time"

	"github.com/google/uuid"
)

type Game struct {
	LocationId int         `json:"-"`
	Questions  []*Question `json:"questions"`
	EndTime    time.Time   `json:"endtime"`
	Submitted  bool        `json:"submitted"`
	RoundNum   int         `json:"round_num"`
}

type Question struct {
	Question   string    `json:"question"`
	QuestionId uuid.UUID `json:"que_id"`
	Option1    *Option   `json:"option1"`
	Option2    *Option   `json:"option2"`
	Option3    *Option   `json:"option3"`
	Option4    *Option   `json:"option4"`
	Correct    int       `json:"-"`
}
type Option struct {
	Option string `json:"option"`
}

var onGoingGames map[uuid.UUID]*Game = make(map[uuid.UUID]*Game)

func Play(db *DB.DB, loc_id int, user_id uuid.UUID) (*Game, error) {
	currentGame, ok := onGoingGames[user_id]
	if !ok || currentGame.Submitted || currentGame.EndTime.Before(time.Now()) {
		currentGame, err := NewGame(db, loc_id)
		if err != nil {
			return nil, err
		}
		onGoingGames[user_id] = currentGame
		return currentGame, nil
	}
	return currentGame, nil

}
func Reset(user_id uuid.UUID) {
	delete(onGoingGames, user_id)
}
func GetGame(user_id uuid.UUID) (*Game, error) {
	currentGame, ok := onGoingGames[user_id]
	if !ok {
		return nil, errors.New("game not found")
	}
	return currentGame, nil
}
func NewGame(db *DB.DB, loc_id int) (*Game, error) {
	query := `select que_id, question, option1, option2, option3, option4, correct from questions where loc_id=$1 order by gen_random_uuid() limit 5`
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
		question := Question{Option1: option1, Option2: option2, Option3: option3, Option4: option4}
		rows.Scan(&question.QuestionId, &question.Question, &option1.Option, &option2.Option, &option3.Option, &option4.Option, &question.Correct)
		if 4 < question.Correct || question.Correct < 1 {
			return nil, errors.New("invalid range of correct answer")
		}
		questions = append(questions, &question)
	}
	return &Game{LocationId: loc_id, Questions: questions, EndTime: time.Now().Add(5 * time.Second), Submitted: false}, nil
}
