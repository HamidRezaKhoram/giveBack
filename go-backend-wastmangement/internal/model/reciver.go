package model

type Receiver struct {
    Email    string `bson:"email"`
    Password string `bson:"password"`
}
