package controllers_tests

import (
	"io"
	"os"
	"testing"
	"fmt"
	"bytes"
	"net/http"
	"path/filepath"
	"encoding/json"
	"mime/multipart"

	"server/src/models"
	"server/src/utils"
	"server/tests/repositories/mocks"
	
	"github.com/stretchr/testify/assert"
)

func TestPostDecks(t *testing.T) {
	setup()

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
			Tags:			  []string{},
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
	formField, _ = w.CreateFormField("card-front-testecardid1")
	formField.Write(imageBytes)
	
	absPath, _ = filepath.Abs("../imagesfortest/sushiraldo.jpg")
	imageBytes, err = os.ReadFile(absPath)
	formField, _ = w.CreateFormField("card-front-testecardid2")
	formField.Write(imageBytes)
	
	absPath, _ = filepath.Abs("../imagesfortest/tirinha.jpg")
	imageBytes, err = os.ReadFile(absPath)
	formField, _ = w.CreateFormField("card-back-testecardid1")
	formField.Write(imageBytes)
	
	absPath, _ = filepath.Abs("../imagesfortest/meme.jpg")
	imageBytes, err = os.ReadFile(absPath)
	formField, _ = w.CreateFormField("card-back-testecardid2")
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
	setup()
	
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

func TestCopyPublicDeck(t *testing.T) {
	setup()
	
	publicCardId := "123cardtest"

	publicDeck := models.Deck {
		UUID: 			"123test",
		Name: 			"Baralho público",
		Description: 	"Baralho público que vai ser copiado",
		IsPublic: 		true,
		Cards: []models.Card{
			models.Card{
					UUID: 		publicCardId,
					FrontText: 	"Frente card",
					BackText:	"Costas card",
			},
		},
	}

	repo, _ := deckRepository.(*repositories_mock.DeckRepositoryMock)
	repo.Decks[publicDeck.UUID] = &publicDeck

	request, err := http.NewRequest(http.MethodPost, "/api/decks/copy/" + string(publicDeck.UUID), nil)
	if err != nil {
		t.FailNow()
	}
	
	router.ServeHTTP(responseRecorder, request)

	assert.Equal(t, http.StatusOK, responseRecorder.Code, "Error status code")

	var deckCopy *models.Deck
	responseBytes, _ := io.ReadAll(responseRecorder.Body)
	err = json.Unmarshal(responseBytes, &deckCopy)
	if err != nil {
		t.FailNow()
	}

	cardOfCopy := deckCopy.Cards[0]

	assert.NotEqual(t, deckCopy.UUID, publicDeck.UUID, "decks UUIDs are the same")
	assert.NotEqual(t, cardOfCopy.UUID, publicCardId, "card UUID is the same")
}

func TestCopyPrivateDeck(t *testing.T) {
	setup()

	privateDeck := models.Deck {
		UUID: 			"abctest",
		Name: 			"Baralho privado",
		Description: 	"Baralho privado que não vai ser copiado",
		IsPublic: 		false,
	}

	repo, _ := deckRepository.(*repositories_mock.DeckRepositoryMock)
	repo.Decks[privateDeck.UUID] = &privateDeck

	request, err := http.NewRequest(http.MethodPost, "/api/decks/copy/" + string(privateDeck.UUID), nil)
	if err != nil {
		t.FailNow()
	}

	router.ServeHTTP(responseRecorder, request)

	assert.Equal(t, http.StatusForbidden, responseRecorder.Code, "Error status code")
}

func TestPutDeckAddingImage(t *testing.T) {
	setup()

	os.Mkdir(utils.GetImagesFilePath() + "/" + deckId, 0755)

	card := models.Card{
		UUID: 		"batata",
		FrontText: 	"Frente card",
		BackText:	"Costas card",
	}

	deck := models.Deck {
		UUID: 				deckId,
		Name: 				"Titulo antigo",
		Description: 		"Descrição antiga",
		Cards: 				[]models.Card{card},
	}
	
	// Add deck in repository
	repo, _ := deckRepository.(*repositories_mock.DeckRepositoryMock)
	repo.Decks[deck.UUID] = &deck

	// Updates in deck: front image for card and deck cover
	updates := map[string]interface{} {
		"name": 		"Novo título",
		"description":	"Esse baralho é demais",
	}

	// Create form
	bodyBuffer := new(bytes.Buffer)
	w := multipart.NewWriter(bodyBuffer)
	
	deckBytes, _ := json.Marshal(updates)
	formField, _ := w.CreateFormField("deck")
	formField.Write(deckBytes)

	absPath, _ := filepath.Abs("../imagesfortest/geraldin.jpg")
	imageBytes, _ := os.ReadFile(absPath)
	formField, _ = w.CreateFormField("deck-image")
	formField.Write(imageBytes)

	absPath, _ = filepath.Abs("../imagesfortest/sushiraldo.jpg")
	imageBytes, _ = os.ReadFile(absPath)
	formField, _ = w.CreateFormField("card-front-" + card.UUID)
	formField.Write(imageBytes)

	w.Close()

	request, err := http.NewRequest(http.MethodPut, "/api/decks/" + deck.UUID , bodyBuffer)
	request.Header.Add("Content-Type", w.FormDataContentType())

	if err != nil {
		t.FailNow()
	}
	
	router.ServeHTTP(responseRecorder, request)

	assert.Equal(t, http.StatusOK, responseRecorder.Code)

	var responseDeck *models.Deck
	response, _ := io.ReadAll(responseRecorder.Body)
	err = json.Unmarshal(response, &responseDeck)
	if err != nil {
		t.FailNow()
	}

	assert.Equal(t, responseDeck.Name, updates["name"])
	assert.Equal(t, responseDeck.Description, updates["description"])
	assert.NotEmpty(t, responseDeck.Cover)
	assert.NotEmpty(t, responseDeck.Cards[0].FrontImagePath)
}

func TestPutDeckRemovingImage(t *testing.T) {
	setup()

	card := models.Card{
		UUID: 			"batata",
		FrontText: 		"Frente card",
		BackText:		"Costas card",
		FrontImagePath:		"http://localhost:8080/image/card-fronttestdeckid-batata.jpeg",
	}

	deck := models.Deck {
		UUID: 				deckId,
		Name: 				"Titulo antigo",
		Description: 		"Descrição antiga",
		Cards: 				[]models.Card{card},
		Cover:				"http://localhost:8080/image/deck-testdeckid.jpeg",
	}
	
	// Add deck in repository
	repo, _ := deckRepository.(*repositories_mock.DeckRepositoryMock)
	repo.Decks[deck.UUID] = &deck

	// Updates in deck: front image for card and deck cover
	updates := map[string]interface{} {
		"cover":		nil,
	}

	// Create form
	bodyBuffer := new(bytes.Buffer)
	w := multipart.NewWriter(bodyBuffer)
	
	deckBytes, _ := json.Marshal(updates)
	formField, _ := w.CreateFormField("deck")
	formField.Write(deckBytes)

	formField, _ = w.CreateFormField("deck-image")
	formField.Write(nil)

	formField, _ = w.CreateFormField("card-front-" + card.UUID)
	formField.Write(nil)

	w.Close()

	request, err := http.NewRequest(http.MethodPut, "/api/decks/" + deck.UUID , bodyBuffer)
	request.Header.Add("Content-Type", w.FormDataContentType())

	if err != nil {
		t.FailNow()
	}
	
	router.ServeHTTP(responseRecorder, request)

	assert.Equal(t, http.StatusOK, responseRecorder.Code)

	var responseDeck *models.Deck
	response, _ := io.ReadAll(responseRecorder.Body)
	err = json.Unmarshal(response, &responseDeck)
	if err != nil {
		t.FailNow()
	}

	assert.Empty(t, responseDeck.Cover)
	assert.Empty(t, responseDeck.Cards[0].FrontImagePath)
}

func TestDeleteDeck(t *testing.T) {
	setup()

	request, err := http.NewRequest(http.MethodDelete, fmt.Sprintf("/api/decks/%s", deckId), nil)
	if err != nil {
		t.FailNow()
	}
	
	router.ServeHTTP(responseRecorder, request)

	assert.Equal(t, http.StatusOK, responseRecorder.Code)
}