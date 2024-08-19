package application

import (
	"context"
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
	_, err = tx.Exec(context.Background(), "update user_rounds set round_num=$1, entered_at=$2 where user_id=$3", round_num+1, time.Now(), user_id)
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
