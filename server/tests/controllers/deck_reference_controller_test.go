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
	setup()

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

func TestGetPublicDeck(t *testing.T) {
	setup()

	testePublicDeckId := "testtest123"
	publicDeck := models.Deck {
		Name: "Batata",
		Description: "Batatinha quando nasce espalha rama ou esparrama?",
		IsPublic: true,
	}

	repoRef, _ := deckReferenceRepository.(*repositories_mock.DeckReferenceRepositoryMock)
	repoDeck, _ := deckRepository.(*repositories_mock.DeckRepositoryMock)

	repoDeck.Decks[testePublicDeckId] = &publicDeck

	repoRef.DeckReferences = []models.DeckReference{
		models.DeckReference{
			Description: 	"Batatinha quando nasce espalha rama ou esparrama?",
			Name:          	"Batata",
			NumberOfCards: 	24,
			Author:         "Geraldinho",
			UUID:			testePublicDeckId,
		},
	}

	request, err := http.NewRequest(http.MethodGet, "/api/decksReference/" + testePublicDeckId, nil)
	if err != nil {
		t.FailNow()
	}

	router.ServeHTTP(responseRecorder, request)

	response, _ := io.ReadAll(responseRecorder.Body)
	deckBytes, _:= json.Marshal(publicDeck)

	assert.Equal(t, http.StatusOK, responseRecorder.Code)
	assert.Nil(t, err)
	assert.Equal(t, string(response), string(deckBytes))
}