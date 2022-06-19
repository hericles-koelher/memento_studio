package main

import (
	"fmt"
	"net/http"
	"server/src/config"
	"server/src/middleware"
	"server/src/repositories"
	"server/src/routes"

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
		context.Set("deckRepository", repositories.NewMongoDeckRepository(database.Collection("deck")))
		context.Set("deckReferenceRepository", repositories.NewMongoDeckReferenceRepository(database.Collection("deck_reference")))
	})
	
	serverApi := server.Group("/api") // só por convenção
	routes.DeckRoutes(serverApi)
	// routes.UserRoutes(serverApi)

	serverApi.GET("/hello-world", func(context *gin.Context) {
		context.JSON(http.StatusOK, gin.H{"message": "Hello my friend"})
	})

	ginErr := server.Run("localhost:8080")

	if ginErr != nil {
		fmt.Println("Error message: " + ginErr.Error())

		return
	}
}
