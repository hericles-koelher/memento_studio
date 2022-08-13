package routes

import (
	"server/src/controllers"

	"github.com/gin-gonic/gin"
)

// Define as rotas de referência de baralho e seus handlers. São elas:
//
// GET '/decksReference' 		handler: ReadAllDeckReference
//
// GET '/decksReference/:id' 	handler: GetPublicDeck
func DeckReferenceRoutes(routerGroup *gin.RouterGroup) {
	deckReferenceGroup := routerGroup.Group("/decksReference")

	deckReferenceGroup.GET("", controllers.ReadAllDeckReference)
	deckReferenceGroup.GET("/:id", controllers.GetPublicDeck)
}
