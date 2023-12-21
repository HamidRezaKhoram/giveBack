package store

import (
    "context"
    "log"
    "os"
    "time"
    "go.mongodb.org/mongo-driver/mongo"
    "go.mongodb.org/mongo-driver/mongo/options"
)

var Client *mongo.Client

func ConnectDB() {
    uri := os.Getenv("MONGO_URI")
    if uri == "" {
        log.Fatal("MONGO_URI not specified in .env")
    }

    var err error
    ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
    defer cancel()

    Client, err = mongo.Connect(ctx, options.Client().ApplyURI(uri))
    if err != nil {
        log.Fatal(err)
    }

    // Test the connection
    err = Client.Ping(ctx, nil)
    if err != nil {
        log.Fatal(err)
    }

    log.Println("Connected to MongoDB!")
}
