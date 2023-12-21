package auth

import (
    "github.com/dgrijalva/jwt-go"
    "os"
    "time"
)

var jwtKey = []byte(os.Getenv("JWT_SECRET"))

type Claims struct {
    Email string `json:"email"`
    jwt.StandardClaims
}

// GenerateToken generates a new JWT token for a user
func GenerateToken(email string) (string, error) {
    expirationTime := time.Now().Add(1 * time.Hour)
    claims := &Claims{
        Email: email,
        StandardClaims: jwt.StandardClaims{
            ExpiresAt: expirationTime.Unix(),
        },
    }

    token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
    tokenString, err := token.SignedString(jwtKey)

    return tokenString, err
}

// ValidateToken validates the JWT token
func ValidateToken(tokenString string) (*jwt.Token, error) {
    claims := &Claims{}

    token, err := jwt.ParseWithClaims(tokenString, claims, func(token *jwt.Token) (interface{}, error) {
        return jwtKey, nil
    })

    return token, err
}
