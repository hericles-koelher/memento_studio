package controllers_tests

import (
	"testing"
	"fmt"
	"bytes"
	"net/http"
	"encoding/json"

	"server/src/models"
	
	"github.com/stretchr/testify/assert"
	
	// "io"
)

func TestDeleteDeck(t *testing.T) {
	request, err := http.NewRequest(http.MethodDelete, fmt.Sprintf("/api/decks/%s", deckId), nil)
	if err != nil {
		t.FailNow()
	}
	
	router.ServeHTTP(responseRecorder, request)

	assert.Equal(t, http.StatusOK, responseRecorder.Code)
}

func TestPostDecks(t *testing.T) {
	decks := []models.Deck {
		models.Deck {
			Name:             "Test 1 Deck",
			Cards:            []models.Card{},
			LastModification: 1654638124,
			IsPublic:         false,
			UUID:             "testdeckid1",
		},
		models.Deck {
			Name:             "Test 2 Deck",
			Cards:            []models.Card{},
			LastModification: 1654638124,
			IsPublic:         true,
			UUID:             "testdeckid2",
		},
	}

	bodyBytes, _ := json.Marshal(decks)
	bodyBuffer := bytes.NewBuffer(bodyBytes)

	request, err := http.NewRequest(http.MethodPost, "/api/decks", bodyBuffer)
	if err != nil {
		t.FailNow()
	}
	
	router.ServeHTTP(responseRecorder, request)

	assert.Equal(t, http.StatusOK, responseRecorder.Code, responseRecorder.Body)

	// response, _ := io.ReadAll(responseRecorder.Body)
	// fmt.Println(string(response))
}

func TestGetDecks(t *testing.T) {
	body := map[string]float64 {
		"limit": 10,
		"page": 1,
	}

	bodyBytes, _ := json.Marshal(body)
	bodyBuffer := bytes.NewBuffer(bodyBytes)

	request, err := http.NewRequest(http.MethodGet, "/api/decks", bodyBuffer)
	if err != nil {
		t.FailNow()
	}
	
	router.ServeHTTP(responseRecorder, request)

	assert.Equal(t, http.StatusOK, responseRecorder.Code, responseRecorder.Body)

	// response, _ := io.ReadAll(responseRecorder.Body)
	// fmt.Println(string(response))
}
