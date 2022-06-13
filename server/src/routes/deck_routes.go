package routes

import (
	"server/src/controllers"

	"github.com/gin-gonic/gin"
)

func DeckRoutes(routerGroup *gin.RouterGroup) {
	deck := routerGroup.Group("/decks")

	deck.GET("/", controllers.GetDecks)
	deck.POST("/", controllers.PostDecks)

	deck.DELETE("/:id", controllers.DeleteDeck)
	deck.GET("/:id", controllers.GetDeck)
}