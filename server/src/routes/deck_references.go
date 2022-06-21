package routes

import (
	"server/src/controllers"

	"github.com/gin-gonic/gin"
)

func DeckReferenceRoutes(routerGroup *gin.RouterGroup) {
	userGroup := routerGroup.Group("/decksReference")
	userGroup.GET("", controllers.ReadAllDeckReference)
}
