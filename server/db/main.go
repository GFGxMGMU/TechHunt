package DB

import (
	"context"
	"fmt"
	"os"

	"github.com/jackc/pgx/v5/pgxpool"
)

type DB struct {
	Pool *pgxpool.Pool
}

func InitDB() *DB {
	dbpool, err := pgxpool.New(context.Background(), "postgres://postgres:gfg_ke_bande@localhost:5432/gfghunt_nakli")
	if err != nil {
		fmt.Println("Something's wrong with the db")
		os.Exit(1)
	}
	return &DB{Pool: dbpool}
}
