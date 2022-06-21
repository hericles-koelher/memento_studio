package routes

import (
	"server/src/controllers"
	"server/src/middlewares"

	"github.com/gin-gonic/gin"
)

func UserRoutes(routerGroup *gin.RouterGroup) {
	userGroup := routerGroup.Group("/users")

	userGroup.Use(middlewares.AuthMiddleware)

	userGroup.DELETE("", controllers.DeleteUser)
	userGroup.GET("", controllers.GetUser)
	userGroup.POST("", controllers.CreateUser)
}
