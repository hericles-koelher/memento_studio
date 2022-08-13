package middlewares

import (
	"context"
	"net/http"
	"strings"

	"firebase.google.com/go/auth"
	"github.com/gin-gonic/gin"
)

// Middleware de autenticação. Pega o token contido no cabeçalho da requisição em 'Authorization', verifica o ID
// do usuário em questão e adiciona no contexto para ser utilizado pelos handlers das requisições.
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
