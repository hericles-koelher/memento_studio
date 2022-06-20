package routes

import (
	"server/src/controllers"

	"github.com/gin-gonic/gin"
)

func UserRoutes(routerGroup *gin.RouterGroup) {
	userGroup := routerGroup.Group("/users")

	userGroup.DELETE("", controllers.DeleteUser)
	userGroup.GET("", controllers.GetUser)
	userGroup.POST("", controllers.CreateUser)
}