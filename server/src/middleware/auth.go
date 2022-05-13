package middleware

import (
	"context"
	"net/http"
	"strings"

	"firebase.google.com/go/auth"
	"github.com/gin-gonic/gin"
)

func AuthMiddleware(ginContext *gin.Context) {
	firebaseAuth := ginContext.MustGet("auth").(*auth.Client)

	authorizationToken := ginContext.GetHeader("Authorization")

	idToken := strings.Replace(authorizationToken, "Bearer ", "", 1)

	if idToken == "" {
		ginContext.JSON(http.StatusBadRequest, gin.H{"error": "Bearer token not available"})
		ginContext.Abort()
		return
	}

	token, err := firebaseAuth.VerifyIDToken(context.Background(), idToken)

	if err != nil {
		ginContext.JSON(http.StatusBadRequest, gin.H{"error": "Invalid token"})
		ginContext.Abort()
		return
	}

	ginContext.Set("UUID", token.UID)
	ginContext.Next()
}
