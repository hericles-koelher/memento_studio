package controllers

import (
	"net/http"
	"server/src/repositories/interfaces"
	"strconv"
	"server/src/utils"

	"github.com/gin-gonic/gin"
)

func ReadAllDeckReference(ginContext *gin.Context) {
	deckReferenceRepo, ok := ginContext.MustGet("deckReferenceRepository").(interfaces.DeckReferenceRepository)

	if !ok {
		ginContext.Status(http.StatusInternalServerError)
		return
	}

	limitString := ginContext.Query("limit")
	pageString := ginContext.Query("page")

	if limitString == "" {
		limitString = "30"
	}

	limit, limitErr := strconv.Atoi(limitString)

	if limitErr != nil || limit < 0 || limit > 100 {
		ginContext.AbortWithStatusJSON(http.StatusBadRequest, "Limite inválido, por favor informe um número inteiro maior que 0 e menor ou igual a 100")
		return
	}

	if pageString == "" {
		pageString = "1"
	}

	page, pageErr := strconv.Atoi(pageString)

	if pageErr != nil || page < 1 {
		ginContext.AbortWithStatusJSON(http.StatusBadRequest, "Página inválida, por favor informe um número inteiro maior que 1")
		return
	}

	var filter map[string]interface{}
	if ginContext.Request.Body != nil {
		err := utils.GetRequestBody(ginContext.Request.Body, &filter)
		if err != nil {
			ginContext.AbortWithStatusJSON(http.StatusBadRequest, err.Error())
			return
		}
	}

	decksReference, decksReferenceErr := deckReferenceRepo.ReadAll(limit, page, filter)

	if decksReferenceErr != nil {
		ginContext.JSON(http.StatusInternalServerError, decksReferenceErr)
		return
	} else {
		ginContext.JSON(http.StatusOK, decksReference)
	}
}

func GetPublicDeck(ginContext *gin.Context) {
	deckRepository, ok := ginContext.MustGet("deckRepository").(interfaces.DeckRepository)
	if !ok {
		ginContext.AbortWithStatusJSON(http.StatusInternalServerError, "error when getting repository")
		return
	}

	// Get deck
	id := ginContext.Param("id")

	deck, errRepo := deckRepository.Read(id)
	if errRepo != nil {
		ginContext.JSON(utils.HandleRepositoryError(errRepo), errRepo.Error())
		return
	}

	// Check if it is public
	if !deck.IsPublic {
		ginContext.AbortWithStatusJSON(http.StatusUnauthorized, "Can't get a private deck")
	}

	// Return deck
	ginContext.JSON(http.StatusOK, deck)
}