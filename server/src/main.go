package main

import (
	"fmt"
	"net/http"
	"server/src/config"
	"server/src/middleware"
	"server/src/repositories"

	"github.com/gin-gonic/gin"
)

const databaseName = "memento_db"

func main() {
	server := gin.Default()

	firebaseAuth := config.SetupFirebase()

	client := config.ConnectToMongoDB()

	database := client.Database(databaseName)

	server.Use(func(context *gin.Context) {
		context.Set("auth", firebaseAuth)
	})

	server.Use(middleware.AuthMiddleware)

	server.Use(func(context *gin.Context) {
		context.Set("userRepository", repositories.NewMongoUserRepository(database.Collection("user")))
	})

	server.GET("/hello-world", func(context *gin.Context) {
		context.JSON(http.StatusOK, gin.H{"message": "Hello my friend"})
	})

	ginErr := server.Run("localhost:8080")

	if ginErr != nil {
		fmt.Println("Error message: " + ginErr.Error())

		return
	}
}
