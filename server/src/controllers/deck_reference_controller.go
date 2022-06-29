package controllers

import (
	"encoding/json"
	"io/ioutil"
	"net/http"
	"server/src/repositories/interfaces"
	"strconv"

	"github.com/gin-gonic/gin"
)

func ReadAllDeckReference(ginContext *gin.Context) {
	deckReferenceRepo, ok := ginContext.MustGet("deckReferenceRepository").(interfaces.DeckReferenceRepository)

	if !ok {
		ginContext.Status(http.StatusInternalServerError)
		return
	}

	limitString := ginContext.Query("limit")
	offsetString := ginContext.Query("offset")

	if limitString == "" {
		limitString = "30"
	}

	limit, limitErr := strconv.Atoi(limitString)

	if limitErr != nil || limit < 0 || limit > 100 {
		ginContext.AbortWithStatusJSON(http.StatusBadRequest, "Limite inválido, por favor informe um número inteiro maior que 0 e menor ou igual a 100")
		return
	}

	if offsetString == "" {
		offsetString = "0"
	}

	offset, offsetErr := strconv.Atoi(offsetString)

	if offsetErr != nil || offset < 0 {
		ginContext.AbortWithStatusJSON(http.StatusBadRequest, "Offset inválido, por favor informe um número inteiro maior que 0")
		return
	}

	var filter map[string]interface{}

	buffer, _ := ioutil.ReadAll(ginContext.Request.Body)

	if len(buffer) > 0 {
		if bodyUnmarshalErr := json.Unmarshal(buffer, &filter); bodyUnmarshalErr != nil {
			ginContext.AbortWithStatusJSON(http.StatusBadRequest, bodyUnmarshalErr)
			return
		}
	}

	decksReference, decksReferenceErr := deckReferenceRepo.ReadAll(limit, offset, filter)

	if decksReferenceErr != nil {
		ginContext.JSON(http.StatusInternalServerError, decksReferenceErr)
		return
	} else {
		ginContext.JSON(http.StatusOK, decksReference)
	}
}