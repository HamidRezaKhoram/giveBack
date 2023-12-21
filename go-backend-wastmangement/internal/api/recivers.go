package api

import (
	"context"
	"log"
	"my-go-project/internal/model"
	"my-go-project/internal/store"
	"net/http"
	"my-go-project/internal/auth"
	"github.com/gin-gonic/gin"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"golang.org/x/crypto/bcrypt"
)

func loginReceiver(c *gin.Context) {
    var credentials model.Receiver // Assume this struct has Email and Password fields
    if err := c.BindJSON(&credentials); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    // Retrieve the stored receiver
    collection := store.Client.Database("food_manager").Collection("receivers")
    var receiver model.Receiver
    err := collection.FindOne(context.Background(), bson.M{"email": credentials.Email}).Decode(&receiver)
    if err != nil {
        c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
        return
    }

    // Compare the provided password with the stored hash
    err = bcrypt.CompareHashAndPassword([]byte(receiver.Password), []byte(credentials.Password))
    if err != nil {
        c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
        return
    }

    // Generate JWT token
    token, err := auth.GenerateToken(receiver.Email)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to generate token"})
        return
    }

    c.JSON(http.StatusOK, gin.H{"token": token})
}


func emailExistsInReceivers(email string) bool {
    collection := store.Client.Database("food_manager").Collection("receivers")
    count, err := collection.CountDocuments(context.Background(), bson.M{"email": email})
    if err != nil {
        log.Printf("Failed to check email existence in receivers: %v", err)
        return false
    }
    return count > 0
}

func createReceiver(c *gin.Context) {
	var newReceiver model.Receiver
    if err := c.BindJSON(&newReceiver); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }
	if emailExistsInReceivers(newReceiver.Email) {
        c.JSON(http.StatusBadRequest, gin.H{"error": "Email already exists"})
        return
    }

    // Hash the password
    hashedPassword, err := bcrypt.GenerateFromPassword([]byte(newReceiver.Password), bcrypt.DefaultCost)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to hash password"})
        return
    }
    newReceiver.Password = string(hashedPassword)

    collection := store.Client.Database("food_manager").Collection("receivers")
    _, err = collection.InsertOne(context.Background(), newReceiver)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Error while inserting new receiver"})
        return
    }

    c.JSON(http.StatusOK, gin.H{"message": "Receiver created successfully"})
}

func getReceivers(c *gin.Context) {
    collection := store.Client.Database("food_manager").Collection("receivers")

    var receivers []model.Receiver
    cursor, err := collection.Find(context.Background(), gin.H{})
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Error while retrieving receivers"})
        return
    }
    defer cursor.Close(context.Background())

    for cursor.Next(context.Background()) {
        var receiver model.Receiver
        if err := cursor.Decode(&receiver); err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Error while decoding receiver"})
            return
        }
        receivers = append(receivers, receiver)
    }

    c.JSON(http.StatusOK, receivers)
}

func getReceiverByEmail(c *gin.Context) {
    email := c.Query("email")
    if email == "" {
        c.JSON(http.StatusBadRequest, gin.H{"error": "Email is required"})
        return
    }

    collection := store.Client.Database("food_manager").Collection("receivers")
    var receiver model.Receiver
    err := collection.FindOne(context.Background(), bson.M{"email": email}).Decode(&receiver)
    if err != nil {
        if err == mongo.ErrNoDocuments {
            c.JSON(http.StatusNotFound, gin.H{"error": "Receiver not found"})
        } else {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Error while retrieving receiver"})
        }
        return
    }

    c.JSON(http.StatusOK, receiver)
}
