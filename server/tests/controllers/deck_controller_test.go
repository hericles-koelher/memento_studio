package controllers_tests

import (
	// "io"
	"os"
	"testing"
	"fmt"
	"bytes"
	"net/http"
	"path/filepath"
	"encoding/json"
	"mime/multipart"

	"server/src/models"
	
	"github.com/stretchr/testify/assert"
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
	cards := []models.Card{
		models.Card {
			FrontText: 	"Texto da frente do card 1",
			BackText:	"Texto de trás do card 1",
			UUID:		"testecardid1",
		},
		models.Card {
			FrontText: 	"Texto da frente do card 2",
			BackText:	"Texto de trás do card 2",
			UUID:		"testecardid2",
		},
	}

	deck := models.Deck {
			Name:             "Test 1 Deck",
			Cards:            cards,
			LastModification: 1654638124,
			IsPublic:         false,
			UUID:             "testdeckid1",
		}
	
	// Create form
	bodyBuffer := new(bytes.Buffer)
	w := multipart.NewWriter(bodyBuffer)
	
	deckBytes, _ := json.Marshal(deck)
	formField, _ := w.CreateFormField("deck")
	formField.Write(deckBytes)

	absPath, _ := filepath.Abs("../imagesfortest/geraldin.jpg")
	imageBytes, err := os.ReadFile(absPath)
	formField, _ = w.CreateFormField("deck-image")
	formField.Write(imageBytes)

	absPath, _ = filepath.Abs("../imagesfortest/laika.jpg")
	imageBytes, err = os.ReadFile(absPath)
	formField, _ = w.CreateFormField("card-front-1")
	formField.Write(imageBytes)
	
	absPath, _ = filepath.Abs("../imagesfortest/sushiraldo.jpg")
	imageBytes, err = os.ReadFile(absPath)
	formField, _ = w.CreateFormField("card-front-2")
	formField.Write(imageBytes)
	
	absPath, _ = filepath.Abs("../imagesfortest/tirinha.jpg")
	imageBytes, err = os.ReadFile(absPath)
	formField, _ = w.CreateFormField("card-back-1")
	formField.Write(imageBytes)
	
	absPath, _ = filepath.Abs("../imagesfortest/meme.jpg")
	imageBytes, err = os.ReadFile(absPath)
	formField, _ = w.CreateFormField("card-back-2")
	formField.Write(imageBytes)

	w.Close()

	request, err := http.NewRequest(http.MethodPost, "/api/decks", bodyBuffer)
	request.Header.Add("Content-Type", w.FormDataContentType())

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
