package routes

import (
	"server/src/controllers"

	"github.com/gin-gonic/gin"
)

func DeckReferenceRoutes(routerGroup *gin.RouterGroup) {
	deckReferenceGroup := routerGroup.Group("/decksReference")

	deckReferenceGroup.GET("", controllers.ReadAllDeckReference)
	deckReferenceGroup.GET("/:id", controllers.GetPublicDeck)
}
