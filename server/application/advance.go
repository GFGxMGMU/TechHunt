package application

import (
	"context"
	"fmt"
	"time"

	"github.com/google/uuid"
)

func (app *Application) Advance(user_id uuid.UUID, round_num int, loc_id int) error {
	fmt.Println(round_num, loc_id)
	tx, err := app.DB.Pool.Begin(context.Background())
	if err != nil {
		fmt.Println(err)
		return err
	}
	defer tx.Rollback(context.Background())
	var previousAdvancers int
	if round_num != 0 {
		err = tx.QueryRow(context.Background(), "select passed_count from location_count where loc_id=$1", loc_id).Scan(&previousAdvancers)
		if err != nil {
			fmt.Println("ek")
			fmt.Println(err)
			return err
		}
	}
	if round_num == 4 {
		if previousAdvancers >= 1 {
			return TooLateError{Message: "You were late :("}
		} else {
			_, err := tx.Exec(context.Background(), "insert into Winner(user_id) values($1)", user_id)
			if err != nil {
				return err
			}
		}
	} else if round_num > 0 {
		if previousAdvancers >= 2 {
			return TooLateError{"You were late :("}
		}
	}

	if round_num != 0 {
		_, err = tx.Exec(context.Background(), "update location_count set passed_count=passed_count+1 where loc_id=$1", loc_id)
		if err != nil {
			fmt.Println("don")
			fmt.Println(err)
			return err
		}
	}
	_, err = tx.Exec(context.Background(), "update user_rounds set submitted=true where round_num=$1 and user_id=$2", round_num, user_id)
	if err != nil {
		fmt.Println("teen")
		fmt.Println(err)
		return err
	}
	if round_num < 5 {
		_, err = tx.Exec(context.Background(), "insert into user_rounds (user_id, round_num, entered_at) values($1, $2, $3)", user_id, round_num+1, time.Now())
		if err != nil {
			fmt.Println("chaar")
			fmt.Println(err)
			return err
		}
		if round_num != 0 {
			_, err = tx.Exec(context.Background(), "update location_users set loc_id = ln.loc_next from location_next ln where user_id=$1 and location_users.loc_id=ln.loc_now", user_id)
			if err != nil {
				fmt.Println("paach")
				fmt.Println(err)
				return err
			}
		}
	}
	err = tx.Commit(context.Background())
	if err != nil {
		fmt.Println("saha")
		fmt.Println(err)
		return err
	}
	return nil

}
