package main

import (
	"log"
	"my-go-project/internal/api"
	"my-go-project/internal/store"
	"time"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func main() {
    err := godotenv.Load()
    if err != nil {
        log.Fatal("Error loading .env file")
    }

    store.ConnectDB() // Connect to MongoDB

    router := gin.Default()

    // Configure CORS
    router.Use(cors.New(cors.Config{
        AllowOrigins:     []string{"*"}, // or use "*" to allow all origins
        AllowMethods:     []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"},
        AllowHeaders:     []string{"Origin", "Content-Type", "Authorization"},
        AllowCredentials: true,
        MaxAge:           12 * time.Hour,
    }))

    // Setup routes
    api.SetupRoutes(router)

    router.Run(":8080")
}
