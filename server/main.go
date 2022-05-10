package main

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"net/http"
	"server/config"
	"server/middleware"
	"go.mongodb.org/mongo-driver/bson"
)

func main() {
	server := gin.Default()

	mongoClient := config.ConnectToMongoDB()
	firebaseAuth := config.SetupFirebase()

	server.Use(func(context *gin.Context) {
		context.Set("auth", firebaseAuth)
	})

	server.Use(middleware.AuthMiddleware)

	server.GET("/hello-world", func(context *gin.Context) {
		context.JSON(http.StatusOK, gin.H{"message": "Hello my friend"})
	})

	server.GET("/cartas", func(context *gin.Context) {
		cursor, err := mongoClient.Database("memento-studio").Collection("cartas").Find(context, bson.M{})

		if err != nil { panic(err) }

		var cards []bson.M
		if err = cursor.All(context, &cards); err != nil {
			panic(err)
		}

		fmt.Println(cards)
		context.JSON(http.StatusOK, cards)
	})

	err := server.Run("localhost:8080")

	if err != nil {
		fmt.Println("Error message: " + err.Error())

		return
	}
}
