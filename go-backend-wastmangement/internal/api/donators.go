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

func loginDonator(c *gin.Context) {
    var credentials model.Donator // Assume this struct has Email and Password fields
    if err := c.BindJSON(&credentials); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    // Retrieve the stored donator
    collection := store.Client.Database("food_manager").Collection("donators")
    var donator model.Donator
    err := collection.FindOne(context.Background(), bson.M{"email": credentials.Email}).Decode(&donator)
    if err != nil {
        c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
        return
    }

    // Compare the provided password with the stored hash
    err = bcrypt.CompareHashAndPassword([]byte(donator.Password), []byte(credentials.Password))
    if err != nil {
        c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
        return
    }

    // Generate JWT token
    token, err := auth.GenerateToken(donator.Email)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to generate token"})
        return
    }

    c.JSON(http.StatusOK, gin.H{"token": token})
}



func emailExistsInDonators(email string) bool {
    collection := store.Client.Database("food_manager").Collection("donators")
    count, err := collection.CountDocuments(context.Background(), bson.M{"email": email})
    if err != nil {
        log.Printf("Failed to check email existence in donators: %v", err)
        return false
    }
    return count > 0
}

func createDonator(c *gin.Context) {
    var newDonator model.Donator
    if err := c.BindJSON(&newDonator); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }
	if emailExistsInDonators(newDonator.Email) {
        c.JSON(http.StatusBadRequest, gin.H{"error": "Email already exists"})
        return
    }

    // Hash the password
    hashedPassword, err := bcrypt.GenerateFromPassword([]byte(newDonator.Password), bcrypt.DefaultCost)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to hash password"})
        return
    }
    newDonator.Password = string(hashedPassword)
	
    collection := store.Client.Database("food_manager").Collection("donators")
    _, err = collection.InsertOne(context.Background(), newDonator)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Error while inserting new donator"})
        return
    }

    c.JSON(http.StatusOK, gin.H{"message": "Donator created successfully"})
}

func getDonators(c *gin.Context) {
    collection := store.Client.Database("food_manager").Collection("donators")

    var donators []model.Donator
    cursor, err := collection.Find(context.Background(), gin.H{})
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": "Error while retrieving donators"})
        return
    }
    defer cursor.Close(context.Background())

    for cursor.Next(context.Background()) {
        var donator model.Donator
        if err := cursor.Decode(&donator); err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Error while decoding donator"})
            return
        }
        donators = append(donators, donator)
    }

    c.JSON(http.StatusOK, donators)
}

func getDonatorByEmail(c *gin.Context) {
    email := c.Query("email")
    if email == "" {
        c.JSON(http.StatusBadRequest, gin.H{"error": "Email is required"})
        return
    }

    collection := store.Client.Database("food_manager").Collection("donators")
    var donator model.Donator
    err := collection.FindOne(context.Background(), bson.M{"email": email}).Decode(&donator)
    if err != nil {
        if err == mongo.ErrNoDocuments {
            c.JSON(http.StatusNotFound, gin.H{"error": "Donator not found"})
        } else {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Error while retrieving donator"})
        }
        return
    }

    c.JSON(http.StatusOK, donator)
}
