package routes

import (
	"server/src/controllers"
	"server/src/middlewares"

	"github.com/gin-gonic/gin"
)

func DeckRoutes(routerGroup *gin.RouterGroup) {
	deck := routerGroup.Group("/decks")

	deck.Use(middlewares.AuthMiddleware)

	deck.GET("", controllers.GetDecks)
	deck.POST("", controllers.PostDecks)
	deck.DELETE("/:id", controllers.DeleteDeck)
	deck.PUT("/:id", controllers.PutDeck)
	deck.POST("/copy/:id", controllers.CopyDeck)
}

func DeckRoutesTest(routerGroup *gin.RouterGroup) {
	deck := routerGroup.Group("/decks")

	deck.GET("", controllers.GetDecks)
	deck.POST("", controllers.PostDecks)
	deck.DELETE("/:id", controllers.DeleteDeck)
	deck.PUT("/:id", controllers.PutDeck)
	deck.POST("/copy/:id", controllers.CopyDeck)
}
