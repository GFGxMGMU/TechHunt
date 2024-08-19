package application

import (
	"context"
	"errors"
	"fmt"
	"time"

	"github.com/google/uuid"
)

func (app *Application) Advance(user_id uuid.UUID, round_num int) error {
	tx, err := app.DB.Pool.Begin(context.Background())
	if err != nil {
		fmt.Println(err)
		return err
	}
	defer tx.Rollback(context.Background())
	var previousAdvancers int
	err = tx.QueryRow(context.Background(), "select passed_count from loc_count where loc_id=$1").Scan(&previousAdvancers)
	if err != nil {
		fmt.Println(err)
		return err
	}
	if previousAdvancers > 2 {
		return errors.New("you were late :(")
	}

	_, err = tx.Exec(context.Background(), "update location_count set passed_count=passed_count+1", user_id)
	if err != nil {
		fmt.Println(err)
		return err
	}

	_, err = tx.Exec(context.Background(), "update user_rounds set submitted=true where round_num=$1 and user_id=$2", round_num, user_id)
	if err != nil {
		fmt.Println(err)
		return err
	}
	_, err = tx.Exec(context.Background(), "insert into user_rounds (user_id, round_num, entered_at) values($1, $2, $3)", user_id, round_num, time.Now())
	if err != nil {
		fmt.Println(err)
		return err
	}
	_, err = tx.Exec(context.Background(), "update location_users as lu set lu.loc_id = ln.loc_next from location_next ln where lu.user_id=$1 and lu.loc_id=ln.loc_now", user_id)
	if err != nil {
		fmt.Println(err)
		return err
	}
	err = tx.Commit(context.Background())
	if err != nil {
		fmt.Println(err)
		return err
	}
	return nil

}
