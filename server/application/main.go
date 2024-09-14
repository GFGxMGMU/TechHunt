package application

import (
	DB "gfghunt/db"
	"time"
)

type Application struct {
	DB        *DB.DB
	Start     bool
	StartTime time.Time
}
