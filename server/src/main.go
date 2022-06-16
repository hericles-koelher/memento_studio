package main

import (
	"fmt"
	"server/src/config"
	"server/src/controllers"
	"server/src/repositories"

	"github.com/gin-gonic/gin"
)

const databaseName = "memento_db"

func main() {
	server := gin.Default()

	firebaseAuth := config.SetupFirebase()

	client := config.ConnectToMongoDB()

	database := client.Database(databaseName)

	// Estruturas que serão utilizadas por todas as rotas
	server.Use(func(context *gin.Context) {
		context.Set("auth", firebaseAuth)
	})

	server.Use(func(context *gin.Context) {
		context.Set("userRepository", repositories.NewMongoUserRepository(database.Collection("user")))
		context.Set("deckReferenceRepository", repositories.NewMongoDeckReferenceRepository(database.Collection("deckReference")))
	})

	// Determinando os endpoints
	routerGroup := server.Group("/api")

	controllers.UserRoutes(routerGroup)
	controllers.DeckReferenceRoutes(routerGroup)

	// Iniciando o server
	ginErr := server.Run("localhost:8080")

	if ginErr != nil {
		fmt.Println("Error message: " + ginErr.Error())

		return
	}
}
