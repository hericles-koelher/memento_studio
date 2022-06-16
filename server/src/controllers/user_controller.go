package controllers

import (
	"net/http"
	"server/src/errors"
	"server/src/models"
	"server/src/repositories/interfaces"
	"time"

	"github.com/gin-gonic/gin"
)

func CreateUser(ginContext *gin.Context) {
	userRepo, ok := ginContext.MustGet("userRepository").(interfaces.UserRepository)

	if !ok {
		ginContext.Status(http.StatusInternalServerError)
		return
	}

	uuid := ginContext.MustGet("UUID").(string)

	user := models.User{
		Decks:               []string{},
		LastSynchronization: time.Now().UnixMilli(),
		UUID:                uuid,
	}

	err := userRepo.Create(&user)

	if err != nil {
		switch err.Code {
		case errors.DuplicateKey:
			ginContext.JSON(http.StatusForbidden, err)
		case errors.Timeout:
			ginContext.JSON(http.StatusRequestTimeout, err)
		default:
			ginContext.JSON(http.StatusInternalServerError, err)
		}
	} else {
		ginContext.JSON(http.StatusCreated, user)
	}
}

// TODO: Deletar também os decks no banco e no sistema de arquivos...
func DeleteUser(ginContext *gin.Context) {
	userRepo, ok := ginContext.MustGet("userRepository").(interfaces.UserRepository)

	if !ok {
		ginContext.Status(http.StatusInternalServerError)
		return
	}

	uuid := ginContext.MustGet("UUID").(string)

	err := userRepo.Delete(uuid)

	if err != nil {
		if err.Code == errors.Timeout {
			ginContext.JSON(http.StatusRequestTimeout, err)
		} else {
			ginContext.JSON(http.StatusInternalServerError, err)
		}
	} else {
		ginContext.Status(http.StatusOK)
	}
}

func GetUser(ginContext *gin.Context) {
	userRepo, ok := ginContext.MustGet("userRepository").(interfaces.UserRepository)

	if !ok {
		ginContext.Status(http.StatusInternalServerError)
		return
	}

	uuid := ginContext.MustGet("UUID").(string)

	user, err := userRepo.Read(uuid)

	if err != nil {
		if err.Code == errors.Timeout {
			ginContext.JSON(http.StatusRequestTimeout, err)
		} else {
			ginContext.JSON(http.StatusInternalServerError, err)
		}
	} else {
		ginContext.JSON(http.StatusOK, user)
	}
}

func UserRoutes(routerGroup *gin.RouterGroup) {
	userGroup := routerGroup.Group("/users")

	userGroup.DELETE("", DeleteUser)
	userGroup.GET("", GetUser)
	userGroup.POST("", CreateUser)
}