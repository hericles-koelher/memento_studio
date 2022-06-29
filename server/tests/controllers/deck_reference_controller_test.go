package controllers_tests

import (
	"io"
	"testing"
	"net/http"
	"encoding/json"

	"server/src/models"
	"server/tests/repositories/mocks"
	
	"github.com/stretchr/testify/assert"
)

func TestReadAllDeckReference(t *testing.T) {
	responseRecorder.Body.Reset()

	repo, _ := deckReferenceRepository.(*repositories_mock.DeckReferenceRepositoryMock)

	repo.DeckReferences = []models.DeckReference{
		models.DeckReference{
			Description: 	"Batatinha quando nasce espalha rama ou esparrama?",
			Name:          	"Batata",
			NumberOfCards: 	24,
			Author:         "Geraldinho",
			UUID:			"testtest123",
		},
	}

	request, err := http.NewRequest(http.MethodGet, "/api/decksReference", nil)
	if err != nil {
		t.FailNow()
	}
	
	router.ServeHTTP(responseRecorder, request)

	var decks []map[string]interface{}
	response, _ := io.ReadAll(responseRecorder.Body)
	err = json.Unmarshal(response, &decks)

	assert.Equal(t, http.StatusOK, responseRecorder.Code)
	assert.Nil(t, err)
	assert.NotEmpty(t, decks)
}
