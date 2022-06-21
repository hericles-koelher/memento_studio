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
}
