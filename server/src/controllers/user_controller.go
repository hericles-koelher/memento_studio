package controllers

import (
	"net/http"
	"server/src/errors"
	"server/src/models"
	"server/src/repositories/interfaces"
	"server/src/utils"
	"time"

	"github.com/gin-gonic/gin"
)

// Handler da requisição de método POST na rota 'api/users'. Cria um usuário a partir do ID gerado a partir do token do header da requisição.
// Se o usuário já existe, não faz nada. A resposta da requisição é o usuário criado ou encontrado no banco.
func CreateUser(ginContext *gin.Context) {
	userRepo, ok := ginContext.MustGet("userRepository").(interfaces.UserRepository)

	if !ok {
		ginContext.Status(http.StatusInternalServerError)
		return
	}

	uuid := ginContext.MustGet("UUID").(string)

	// Checa se usuário ja existe
	existingUser, _ := userRepo.Read(uuid)

	if existingUser != nil {
		ginContext.JSON(http.StatusOK, existingUser)
		return
	}

	user := models.User{
		Decks:               []string{},
		LastSynchronization: time.Now().UnixMilli(),
		UUID:                uuid,
	}

	err := userRepo.Create(&user)

	if err != nil {
		switch err.Code {
		case errors.DuplicateKey:
			ginContext.AbortWithStatusJSON(http.StatusForbidden, err)
		case errors.Timeout:
			ginContext.AbortWithStatusJSON(http.StatusRequestTimeout, err)
		default:
			ginContext.AbortWithStatusJSON(http.StatusInternalServerError, err)
		}
	} else {
		ginContext.JSON(http.StatusCreated, user)
	}
}

// Handler da requisição de método DELETE na rota 'api/users'. Deleta o usuário que fez a requisição.
// Além disso, deleta todos os baralhos, referência de baralho e imagens.
// A resposta da requisição é vazia.
func DeleteUser(ginContext *gin.Context) {
	userRepo, okUser := ginContext.MustGet("userRepository").(interfaces.UserRepository)
	deckRepo, okDeck := ginContext.MustGet("deckRepository").(interfaces.DeckRepository)
	deckRefRepo, okDeckRef := ginContext.MustGet("deckReferenceRepository").(interfaces.DeckReferenceRepository)

	if !okUser || !okDeck || !okDeckRef {
		ginContext.Status(http.StatusInternalServerError)
		return
	}

	uuid := ginContext.MustGet("UUID").(string)
	user, err := userRepo.Read(uuid)

	// Delete decks and its data
	for _, deckId := range user.Decks {
		// Delete deck
		errRepo := deckRepo.Delete(deckId)
		if errRepo != nil {
			ginContext.JSON(utils.HandleRepositoryError(errRepo), errRepo.Error())
			return
		}
		// Delete public reference if it exists
		deckRefRepo.Delete(deckId)

		// Delete folder with images
		utils.RemoveFolder(deckId)
	}

	err = userRepo.Delete(uuid)

	if err != nil {
		ginContext.AbortWithStatusJSON(utils.HandleRepositoryError(err), err.Error())
	} else {
		ginContext.Status(http.StatusOK)
	}
}

// Handler da requisição de método GET na rota 'api/users'. Retorna o usuário em questão contendo UUID,
// última sincronização e lista de ids de bralhos que possui.
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
			ginContext.AbortWithStatusJSON(http.StatusRequestTimeout, err)
		} else {
			ginContext.AbortWithStatusJSON(http.StatusInternalServerError, err)
		}
	} else {
		ginContext.JSON(http.StatusOK, user)
	}
}
