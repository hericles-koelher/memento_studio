package main

import (
	"fmt"
	"server/src/config"
	"server/src/controllers"
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

	// Estruturas que serão utilizadas por todas as rotas
	server.Use(func(context *gin.Context) {
		context.Set("auth", firebaseAuth)
	})

	// TODO: Decidir como modificar esse middleware aqui,
	// pois a rota de referencias deve ser acessivel sem autenticação
	server.Use(middleware.AuthMiddleware)

	server.Use(func(context *gin.Context) {
		context.Set("userRepository", repositories.NewMongoUserRepository(database.Collection("user")))
	})

	// Determinando os endpoints
	routerGroup := server.Group("/api")

	controllers.UserRoutes(routerGroup)

	ginErr := server.Run("localhost:8080")

	if ginErr != nil {
		fmt.Println("Error message: " + ginErr.Error())

		return
	}
}
