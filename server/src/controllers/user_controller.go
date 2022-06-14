package controllers

import (
	"net/http"
	"server/src/models"
	"server/src/repositories"
	"time"

	"github.com/gin-gonic/gin"
)

func CreateUser(ginContext *gin.Context) {
	userRepo := ginContext.MustGet("userRepository").(*repositories.MongoUserRepository)

	uuid := ginContext.MustGet("UUID").(string)

	user := models.User{
		Decks:               []string{},
		LastSynchronization: time.Now().UnixMilli(),
		UUID:                uuid,
	}

	err := userRepo.Create(&user)

	if err != nil {
		ginContext.JSON(http.StatusInternalServerError, gin.H{"report": "Um erro aconteceu"})
	} else {
		ginContext.JSON(http.StatusCreated, user)
	}
}

func GetUser(ginContext *gin.Context) {
	userRepo := ginContext.MustGet("userRepository").(*repositories.MongoUserRepository)

	uuid := ginContext.MustGet("UUID").(string)

	user, err := userRepo.Read(uuid)

	// Tem que especificar o erro pra que seja possivel ter um tratamento mais adequado.
	if err != nil {
		ginContext.JSON(http.StatusInternalServerError, gin.H{"report": "Um erro aconteceu"})
	} else {
		ginContext.JSON(http.StatusOK, user)
	}
}

func UserRoutes(routerGroup *gin.RouterGroup) {
	userGroup := routerGroup.Group("/users")

	userGroup.POST("", CreateUser)
	userGroup.GET("", GetUser)
}
