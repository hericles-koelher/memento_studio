package main

import (
	"fmt"
	"net/http"
	"server/src/config"
	"server/src/middleware"

	"github.com/gin-gonic/gin"
)

func main() {
	server := gin.Default()

	firebaseAuth := config.SetupFirebase()

	server.Use(func(context *gin.Context) {
		context.Set("auth", firebaseAuth)
	})

	server.Use(middleware.AuthMiddleware)

	server.GET("/hello-world", func(context *gin.Context) {
		context.JSON(http.StatusOK, gin.H{"message": "Hello my friend"})
	})

	err := server.Run("localhost:8080")

	if err != nil {
		fmt.Println("Error message: " + err.Error())

		return
	}
}
