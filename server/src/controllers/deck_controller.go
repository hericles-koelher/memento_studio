package controllers

import (
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"mime/multipart"
	"net/http"
	"regexp"
	"strings"
	"time"

	"server/src/errors"
	"server/src/models"
	. "server/src/repositories/interfaces"
	"server/src/utils"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type fileBytes []byte

// Deleta baralhos a partir de uma lista recebida
func DeleteDeck(context *gin.Context) {
	// Get repositories
	deckRepository, okDeck := context.MustGet("deckRepository").(DeckRepository)
	deckReferenceRepository, okDeckReference := context.MustGet("deckReferenceRepository").(DeckReferenceRepository)
	userRepository, okUser := context.MustGet("userRepository").(UserRepository)
	if !okDeck || !okDeckReference || !okUser {
		context.JSON(http.StatusInternalServerError, gin.H{"message": "Could not delete decks"})
		return
	}

	// Get list of decks
	var ids []string
	bodyBytes, _ := ioutil.ReadAll(context.Request.Body)
	defer context.Request.Body.Close()

	err := json.Unmarshal(bodyBytes, &ids)
	if err != nil {
		context.JSON(http.StatusBadRequest, err.Error())
		return
	}

	// Get user
	user := getUser(context, userRepository)
	if user == nil {
		return
	}

	for _, id := range ids {
		// Check if user owns this deck
		var containsDeck = utils.Contains(user.Decks, id,
			func(id1, id2 interface{}) bool {
				return id1.(string) == id2.(string)
			})
		if !containsDeck {
			continue
		}

		// Delete deck reference if it is public
		deckReferenceRepository.Delete(id)

		// Delete files of deck
		utils.RemoveFolder(id)

		// Delete deck
		err := deckRepository.Delete(id)
		if err != nil {
			context.JSON(utils.HandleRepositoryError(err), err.Error())
			return
		}

		// Remove deck id from user decks
		user.Decks = utils.Remove(user.Decks, id)
		errRepo := userRepository.UpdateDecks(user.UUID, user.Decks)
		if errRepo != nil {
			context.JSON(utils.HandleRepositoryError(errRepo), errRepo.Error())
			return
		}
	}

	context.JSON(http.StatusOK, gin.H{"message": fmt.Sprintf("Decks with ids %s have been deleted", ids)})
}

func PostDecks(context *gin.Context) {
	// Get repositories
	deckRepository, okDeck := context.MustGet("deckRepository").(DeckRepository)
	deckReferenceRepository, okDeckReference := context.MustGet("deckReferenceRepository").(DeckReferenceRepository)
	userRepository, okUser := context.MustGet("userRepository").(UserRepository)
	if !okDeck || !okDeckReference || !okUser {
		context.JSON(http.StatusInternalServerError, gin.H{"message": "Could not post deck"})
		return
	}

	// Get user
	user := getUser(context, userRepository)
	if user == nil {
		return
	}

	// Get deck in requisition
	reader, err := context.Request.MultipartReader()
	if err != nil {
		context.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	deckBytes, deckCover, cardsFront, cardsBack, err := getDeckWithImages(reader)
	if err != nil {
		context.JSON(http.StatusBadRequest, err.Error())
		return
	}

	var deck models.Deck
	err = json.Unmarshal(deckBytes, &deck)
	if err != nil {
		context.JSON(http.StatusBadRequest, err.Error())
		return
	}

	// Fill deck
	deckImgName := "deck-" + deck.UUID + ".jpeg"
	if len(deckCover) > 0 {
		filepath, err := utils.UploadFile(deckCover, deck.UUID, deckImgName)
		if err != nil {
			context.JSON(http.StatusInternalServerError, err.Error())
			return
		}
		deck.Cover = filepath
	} else {
		utils.RemoveFile(deckImgName, deck.UUID)
		deck.Cover = ""
	}

	// Update cards
	cardsUpdated := []models.Card{}
	for _, card := range deck.Cards {
		var newCard = new(models.Card)
		newCard.FrontText = card.FrontText
		newCard.BackText = card.BackText
		newCard.UUID = card.UUID

		if card.UUID == "" {
			newCard.UUID = uuid.New().String()
		}

		// Save images and set the filepath for its images
		frontName := "card-front" + deck.UUID + "-" + card.UUID + ".jpeg"
		if cardsFront[card.UUID] != nil && len(cardsFront[card.UUID]) > 0 {
			filepathFront, errFront := utils.UploadFile(cardsFront[card.UUID], deck.UUID, frontName)

			if errFront != nil {
				context.JSON(http.StatusInternalServerError, errFront.Error())
				return
			}

			newCard.FrontImagePath = filepathFront
		} else {
			utils.RemoveFile(frontName, deck.UUID)
			newCard.FrontImagePath = ""
		}

		backName := "card-back" + deck.UUID + "-" + card.UUID + ".jpeg"
		if cardsBack[card.UUID] != nil && len(cardsFront[card.UUID]) > 0 {
			filepathBack, errBack := utils.UploadFile(cardsBack[card.UUID], deck.UUID, backName)

			if errBack != nil {
				context.JSON(http.StatusInternalServerError, errBack.Error())
				return
			}

			newCard.BackImagePath = filepathBack
		} else {
			utils.RemoveFile(backName, deck.UUID)
			newCard.BackImagePath = ""
		}

		cardsUpdated = append(cardsUpdated, *newCard)
	}

	deck.Cards = cardsUpdated
	_, _, errRepo := deckRepository.InsertOrUpdate(&deck)
	if errRepo != nil {
		context.JSON(utils.HandleRepositoryError(errRepo), errRepo.Error())
		return
	}

	// Insert or update deckReference
	errRepo = updateIsPublicStatus(deck, deckReferenceRepository)
	if errRepo != nil {
		context.JSON(utils.HandleRepositoryError(errRepo), errRepo.Error())
		return
	}

	// Update user's decks ids if it is a new deck
	deckIds := user.Decks
	userHasDeck := utils.Contains(user.Decks, deck.UUID,
		func(id1, id2 interface{}) bool {
			return id1.(string) == id2.(string)
		})

	if !userHasDeck {
		deckIds = append(deckIds, deck.UUID)
	}

	errRepo = userRepository.UpdateDecks(user.UUID, deckIds)
	if errRepo != nil {
		context.JSON(utils.HandleRepositoryError(errRepo), errRepo.Error())
		return
	}

	context.JSON(http.StatusOK, deck)
}

func GetDecks(context *gin.Context) {
	// Get repositories
	deckRepository, okDeck := context.MustGet("deckRepository").(DeckRepository)
	userRepository, okUser := context.MustGet("userRepository").(UserRepository)
	if !okDeck || !okUser {
		context.JSON(http.StatusInternalServerError, gin.H{"message": "Could not get decks"})
		return
	}

	// Get user
	user := getUser(context, userRepository)
	if user == nil {
		return
	}

	// Get requisition's body
	var reqBody map[string]interface{}

	if context.Request.Body != nil {
		err := utils.GetRequestBody(context.Request.Body, &reqBody)
		if err != nil {
			context.JSON(http.StatusBadRequest, err.Error())
			return
		}
	}

	// Get decks from db
	limit, okLim := reqBody["limit"].(float64)
	page, okPage := reqBody["page"].(float64)
	if !okLim {
		limit = 30
	}

	if !okPage {
		page = 1
	}

	decksResult, errRepo := deckRepository.ReadAll(user.Decks, (int)(limit), (int)(page))
	if errRepo != nil {
		context.JSON(utils.HandleRepositoryError(errRepo), errRepo.Error())
		return
	}

	context.JSON(http.StatusOK, decksResult)
}

func CopyDeck(context *gin.Context) {
	// Get repositories
	deckRepository, okDeck := context.MustGet("deckRepository").(DeckRepository)
	userRepository, okUser := context.MustGet("userRepository").(UserRepository)
	if !okDeck || !okUser {
		context.JSON(http.StatusInternalServerError, gin.H{"message": "Could not copy deck"})
		return
	}

	// Get param
	id := context.Param("id")

	// Get deck from db
	deck, errRepo := deckRepository.Read(id)
	if errRepo != nil {
		context.JSON(utils.HandleRepositoryError(errRepo), errRepo.Error())
		return
	}

	// Check if deck is public
	if !deck.IsPublic {
		context.JSON(http.StatusForbidden, "Cannot copy a private deck")
		return
	}

	// Make copy
	deckCopy := *deck
	deckCopy.UUID = uuid.New().String()
	deckCopy.IsPublic = false
	deckCopy.LastModification = time.Now().UnixMilli()

	var newCards = []models.Card{}
	for _, card := range deck.Cards {
		card.UUID = uuid.New().String()
		newCards = append(newCards, card)
	}
	deckCopy.Cards = newCards

	// Add deck to user collection
	user := getUser(context, userRepository)
	if user == nil {
		return
	}

	user.Decks = append(user.Decks, deckCopy.UUID)

	// Save deck and user updated
	_, _, errRepo = deckRepository.InsertOrUpdate(&deckCopy)
	if errRepo != nil {
		context.JSON(utils.HandleRepositoryError(errRepo), errRepo.Error())
		return
	}

	errRepo = userRepository.UpdateDecks(user.UUID, user.Decks)
	if errRepo != nil {
		context.JSON(utils.HandleRepositoryError(errRepo), errRepo.Error())
		return
	}

	context.JSON(http.StatusOK, deckCopy)
	return
}

// --------------------- Aux functions --------------------- //

func getUser(context *gin.Context, userRepository UserRepository) *models.User {
	userContextId, _ := context.Get("UUID")
	userid, _ := userContextId.(string)

	user, err := userRepository.Read(userid)
	if err != nil {
		context.JSON(utils.HandleRepositoryError(err), err.Error())
		return nil
	}

	return user
}

func getDeckWithImages(reader *multipart.Reader) ([]byte, fileBytes, map[string]fileBytes, map[string]fileBytes, error) {
	var deck fileBytes
	var deckCover fileBytes
	cardFrontImages := map[string]fileBytes{}
	cardBackImages := map[string]fileBytes{}

	var regexCardFront = regexp.MustCompile("card-front-(.+)")
	var regexCardBack = regexp.MustCompile("card-back-(.+)")

	part, err := reader.NextPart()
	for ; err != io.EOF; part, err = reader.NextPart() {
		if err != nil {
			return nil, nil, nil, nil, err
		}

		switch name := part.FormName(); {
		case name == "deck":
			deck, err = ioutil.ReadAll(part)
			part.Close()

		case name == "deck-image":
			deckCover, err = ioutil.ReadAll(part)
			part.Close()

		case regexCardFront.MatchString(name):
			var bytesImg []byte
			bytesImg, err = ioutil.ReadAll(part)
			part.Close()

			cardId := strings.Replace(name, "card-front-", "", -1)
			cardFrontImages[cardId] = bytesImg

		case regexCardBack.MatchString(name):
			var bytesImg []byte
			bytesImg, err = ioutil.ReadAll(part)
			part.Close()

			cardId := strings.Replace(name, "card-back-", "", -1)
			cardBackImages[cardId] = bytesImg
		}

		if err != nil {
			return nil, nil, nil, nil, err
		}
	}

	return deck, deckCover, cardFrontImages, cardBackImages, nil
}

func updateIsPublicStatus(deck models.Deck, deckReferenceRepository DeckReferenceRepository) *errors.RepositoryError {
	if deck.IsPublic { // Create or update deck reference
		var deckReference = new(models.DeckReference)
		deckReference.Cover = deck.Cover
		deckReference.Description = deck.Description
		deckReference.Name = deck.Name
		deckReference.NumberOfCards = len(deck.Cards)
		deckReference.Tags = deck.Tags
		deckReference.UUID = deck.UUID

		_, _, errRepo := deckReferenceRepository.InsertOrUpdate(deckReference)
		if errRepo != nil {
			return errRepo
		}
	} else { // Remove deck reference
		deckReferenceRepository.Delete(deck.UUID)
	}

	return nil
}
