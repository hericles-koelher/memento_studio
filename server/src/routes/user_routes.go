package routes

import (
	"server/src/controllers"
	"server/src/middlewares"

	"github.com/gin-gonic/gin"
)

// Define as rotas de usuário e seus handlers. São elas:
//
// GET 		'/users' 	handler: GetUser
//
// DELETE	'/users'	handler: DeleteUser
//
// POST'	'/users'	handler: CreateUser
func UserRoutes(routerGroup *gin.RouterGroup) {
	userGroup := routerGroup.Group("/users")

	userGroup.Use(middlewares.AuthMiddleware)

	userGroup.DELETE("", controllers.DeleteUser)
	userGroup.GET("", controllers.GetUser)
	userGroup.POST("", controllers.CreateUser)
}

// Define as rotas de usuário e seus handlers para teste assim como a função DeckRoutes.
// Não adiciona o middleware de autenticação.
func UserRoutesTest(routerGroup *gin.RouterGroup) {
	userGroup := routerGroup.Group("/users")

	userGroup.DELETE("", controllers.DeleteUser)
	userGroup.GET("", controllers.GetUser)
	userGroup.POST("", controllers.CreateUser)
}
