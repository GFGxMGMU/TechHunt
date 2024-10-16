package application

import (
	"context"
	"fmt"
	"sync"
	"time"

	"github.com/google/uuid"
)

type GlobalState struct {
	LeaderBoard LeaderBoard
	Eliminated  map[uuid.UUID]bool
	mu          sync.Mutex
}

type LeaderBoard struct {
	LeaderBoard []*LeaderBoardEntry `json:"leaderboard"`
	WinnerId    uuid.UUID
	WinnerName  string
	IsWinner    bool
	err         error
}
type LeaderBoardEntry struct {
	TeamName  string `json:"team_name"`
	RoundNum  int    `json:"round"`
	EnteredAt string `json:"entered_at"`
}

var globalState *GlobalState

func (app *Application) Init() {
	globalState = new(GlobalState)
	globalState.LeaderBoard = LeaderBoard{}
	globalState.LeaderBoard.LeaderBoard = make([]*LeaderBoardEntry, 32)
	ticker := time.NewTicker(5 * time.Second)
	stop := make(chan bool)
	app.LeaderBoardAndWinner()
LeaderBoardChecker:
	for {
		select {
		case <-ticker.C:
			app.LeaderBoardAndWinner()
			if globalState.LeaderBoard.IsWinner {
				ticker.Stop()
				stop <- true
			}
		case <-stop:
			break LeaderBoardChecker
		}
	}
}

func (app *Application) getCurrentLeaderBoard() *LeaderBoard {
	return &globalState.LeaderBoard
}

func (app *Application) LeaderBoardAndWinner() error {
	globalState.mu.Lock()
	defer globalState.mu.Unlock()
	globalState.LeaderBoard.LeaderBoard = make([]*LeaderBoardEntry, 0)
	rows, err := app.DB.Pool.Query(context.Background(), "select team_name, round_num, entered_at from user_rounds ur natural join users y where ur.submitted=false order by round_num desc, entered_at asc, team_name asc")
	if err != nil {
		fmt.Println("Leaderboard not leaderboarding", err.Error())
		globalState.LeaderBoard.err = err
		return err
	}
	currentLeaderBoard := &globalState.LeaderBoard
	timezone, err := time.LoadLocation("Asia/Kolkata")
	for {
		if !rows.Next() {
			break
		}
		currentLeaderBoardEntry := LeaderBoardEntry{}
		var enteredAt time.Time
		rows.Scan(&currentLeaderBoardEntry.TeamName, &currentLeaderBoardEntry.RoundNum, &enteredAt)
		currentLeaderBoardEntry.EnteredAt = enteredAt.In(timezone).Format(time.RFC822)
		currentLeaderBoard.LeaderBoard = append(currentLeaderBoard.LeaderBoard, &currentLeaderBoardEntry)
	}
	if err != nil {
		fmt.Println("Leaderboard not leaderboarding", err.Error())
		globalState.LeaderBoard.err = err
		return err
	}
	err = app.DB.Pool.QueryRow(context.Background(), "select user_id, team_name from winner natural join users").Scan(&currentLeaderBoard.WinnerId, &currentLeaderBoard.WinnerName)
	if err == nil {
		currentLeaderBoard.IsWinner = true
		globalState.LeaderBoard.err = nil
	}

	rows, err = app.DB.Pool.Query(context.Background(), "select user_id from eliminated;")
	if err != nil {
		fmt.Println("Eliminator not eliminatoring", err.Error())
		globalState.LeaderBoard.err = err
		return err
	}
	globalState.Eliminated = make(map[uuid.UUID]bool)
	for {
		if !rows.Next() {
			break
		}
		var user_id uuid.UUID
		err = rows.Scan(&user_id)

		if err != nil {
			fmt.Println("Eliminator not eliminatoring", err.Error())
			globalState.LeaderBoard.err = err
			return err
		}
		globalState.Eliminated[user_id] = true
	}
	fmt.Println(globalState.Eliminated)
	return nil
}
