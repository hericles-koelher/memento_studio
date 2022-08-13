package routes

import (
	"server/src/controllers"
	"server/src/middlewares"

	"github.com/gin-gonic/gin"
)

// Define as rotas de baralho e seus handlers. São elas:
//
// GET 		'/decks' 	handler: GetDecks
//
// POST 	'/decks' 	handler: PostDecks
//
// DELETE	'/decks'	handler: DeleteDeck
//
// POST'	'/copy/:id'	handler: CopyDeck
func DeckRoutes(routerGroup *gin.RouterGroup) {
	deck := routerGroup.Group("/decks")

	deck.Use(middlewares.AuthMiddleware)

	deck.GET("", controllers.GetDecks)
	deck.POST("", controllers.PostDecks)
	deck.DELETE("", controllers.DeleteDeck)
	deck.POST("/copy/:id", controllers.CopyDeck)
}

// Define as rotas de baralho e seus handlers para teste assim como a função DeckRoutes.
// Não adiciona o middleware de autenticação.
func DeckRoutesTest(routerGroup *gin.RouterGroup) {
	deck := routerGroup.Group("/decks")

	deck.GET("", controllers.GetDecks)
	deck.POST("", controllers.PostDecks)
	deck.DELETE("", controllers.DeleteDeck)
	deck.POST("/copy/:id", controllers.CopyDeck)
}
