package model

import "time"

type Donator struct {
    Email     string            `bson:"email"`
    Password  string            `bson:"password"`
    History   map[time.Time]int `bson:"history"` // Assuming int is for the amount
}
