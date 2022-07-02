package controllers

import (
	"net/http"
	"fmt"
	"io"
	"io/ioutil"
	"regexp"
	"mime/multipart"
	"encoding/json"

	. "server/src/repositories/interfaces"
	"server/src/utils"
	"server/src/models"
	"server/src/errors"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type fileBytes []byte

// TODO: Melhorar erros pra retornar uma mensagem e código apropriados

func DeleteDeck(context *gin.Context) {
	// Get repositories
	deckRepository, okDeck := context.MustGet("deckRepository").(DeckRepository)
	userRepository, okUser := context.MustGet("userRepository").(UserRepository)
	if !okDeck || !okUser {
		context.JSON(http.StatusInternalServerError, gin.H{"message": "Could not delete deck"})
		return
	}

	// Get param
	id := context.Param("id")

	// Get user
	user := getUser(context, userRepository)
	if user == nil { return }

	// Check if user owns that deck
	var containsDeck = utils.Contains(user.Decks, id, 
		func (id1, id2 interface{}) bool {
			return id1.(string) == id2.(string)
		})
	if !containsDeck {
		context.JSON(http.StatusUnauthorized, gin.H{"message": "User has no permission to delete this deck"})
		return
	}

	// Delete deck
	err := deckRepository.Delete(id)
	if err != nil {
		context.JSON(handleRepositoryError(err), err.Error())
		return
	}

	context.JSON(http.StatusOK, gin.H{"message": fmt.Sprintf("Deck with id %s has been deleted", id)})
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
	if user == nil { return }
	
	// Get deck in requisition
	reader, err := context.Request.MultipartReader()
	if err != nil {
        context.JSON(http.StatusInternalServerError, err.Error())
        return
    }

	deck, deckCover, cardsFront, cardsBack, err := getDeckWithImages(reader)
	if err != nil {
        context.JSON(http.StatusBadRequest, err.Error())
        return
    }

	// Fill deck
	deckImgName := "deck-" + deck.UUID + ".jpeg"
	filepath, err := utils.UploadFile(deckCover, deckImgName)
	if err != nil {
        context.JSON(http.StatusInternalServerError, err.Error())
        return
    }
	deck.Cover = filepath

	// Check if deck is new or if user owns it
	var isNewDeck bool
	if deck.UUID == "" {
		isNewDeck = true
		deck.UUID = uuid.New().String()
	} else {
		userHasDeck := !utils.Contains(user.Decks, deck.UUID, 
			func (id1, id2 interface{}) bool {
				return id1.(string) == id2.(string)
			})
		
		if !userHasDeck {
			context.JSON(http.StatusUnauthorized, "User has no permission to update this deck")
			return
		}

		isNewDeck = false
	}
	
	// Update cards
	cardsUpdated := []models.Card{}
	for idx, card := range deck.Cards {
		if card.UUID == "" {
			card.UUID = uuid.New().String()
		}

		// Save images and set the filepath for its images
		frontName := "card-front" + deck.UUID + "-" + card.UUID + ".jpeg"
		filepathFront, errFront := utils.UploadFile(cardsFront[idx], frontName)

		backName := "card-back" + deck.UUID + "-" + card.UUID + ".jpeg"
		filepathBack, errBack := utils.UploadFile(cardsBack[idx], backName)

		if errFront != nil || errBack != nil {
			context.JSON(http.StatusInternalServerError, err.Error())
        	return
		}

		card.FrontImagePath = filepathFront
		card.BackImagePath = filepathBack

		cardsUpdated = append(cardsUpdated, card)
	}

	deck.Cards = cardsUpdated
	_, _, errRepo := deckRepository.InsertOrUpdate(deck)
	if err != nil {
		context.JSON(handleRepositoryError(errRepo), errRepo.Error())
		return
	}

	// Insert or update deckReference
	if deck.IsPublic {
		var deckReference = new(models.DeckReference)
		deckReference.Cover = deck.Cover
		deckReference.Description = deck.Description
		deckReference.Name = deck.Name
		deckReference.NumberOfCards = len(deck.Cards)
		deckReference.Tags = deck.Tags
		deckReference.UUID = deck.UUID

		_, _, errRepo = deckReferenceRepository.InsertOrUpdate(deckReference)
		if err != nil {
			context.JSON(handleRepositoryError(errRepo), errRepo.Error())
			return
		}
	}

	// Update user's decks ids if is a new deck
	deckIds := user.Decks
	if isNewDeck {
		deckIds = append(deckIds, deck.UUID)
	}

	errRepo = userRepository.UpdateDecks(user.UUID, deckIds)
	if errRepo != nil {
		context.JSON(handleRepositoryError(errRepo), errRepo.Error())
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
	if user == nil { return }

	// Get requisition's body
	var reqBody map[string]interface{}
	err := utils.GetRequestBody(context.Request.Body, &reqBody)
	if err != nil {
		context.JSON(http.StatusBadRequest, err.Error())
		return
	}

	// Get decks from db
	if reqBody["limit"] == nil {
		reqBody["limit"] = 30
	}
	if reqBody["page"] == nil {
		reqBody["page"] = 1
	}

	limit, okLim := reqBody["limit"].(float64)
	page, okPage := reqBody["page"].(float64)
	if !okLim || !okPage {
		context.JSON(http.StatusBadRequest, "Limite e página devem ser um número")
		return
	}

	decksResult, errRepo := deckRepository.ReadAll(user.Decks, (int)(limit), (int)(page))
	if errRepo != nil {
		context.JSON(handleRepositoryError(errRepo), errRepo.Error())
		return
	}
	
	context.JSON(http.StatusOK, decksResult)
}

func CopyDeck(context *gin.Context) {
	// Get repositories
	deckRepository, okDeck := context.MustGet("deckRepository").(DeckRepository)
	userRepository, okUser := context.MustGet("userRepository").(UserRepository)
	if !okDeck || !okUser {
		context.JSON(http.StatusInternalServerError, gin.H{"message": "Could copy deck"})
		return
	}

	// Get param
	id := context.Param("id")

	// Get deck from db
	deck, errRepo := deckRepository.Read(id)
	if errRepo != nil {
		context.JSON(handleRepositoryError(errRepo), errRepo.Error())
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

	var newCards = []models.Card{}
	for _, card:= range deck.Cards {
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
		context.JSON(handleRepositoryError(errRepo), errRepo.Error())
		return
	}

	errRepo = userRepository.UpdateDecks(user.UUID, user.Decks)
	if errRepo != nil {
		context.JSON(handleRepositoryError(errRepo), errRepo.Error())
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
		context.JSON(handleRepositoryError(err), err.Error())
		return nil
	}

	return user
}

func handleRepositoryError(err *errors.RepositoryError) int {
	switch err.Code {
	case errors.DuplicateKey:
		return http.StatusForbidden
	case errors.Timeout:
		return http.StatusRequestTimeout
	default:
		return http.StatusInternalServerError
	}
}

func getDeckWithImages(reader *multipart.Reader) (*models.Deck, fileBytes, []fileBytes, []fileBytes, error) {
	var deck 			models.Deck
	var deckCover 	 	fileBytes
	cardFrontImages := 	[]fileBytes{}
	cardBackImages 	:= 	[]fileBytes{}

	var regexCardFront = regexp.MustCompile("card-front-([0-9]+)")
	var regexCardBack = regexp.MustCompile("card-back-([0-9]+)")

	part, err := reader.NextPart()
	for ; err != io.EOF; part, err = reader.NextPart() {
		if err != nil {
			return nil, nil, nil, nil, err
		}
		
		switch name := part.FormName(); {
		case name == "deck":
			jsonDecoder := json.NewDecoder(part)
            err = jsonDecoder.Decode(&deck)

			if err != nil {
				return nil, nil, nil, nil, err
			}
		case name == "deck-image":
			deckCover, err = ioutil.ReadAll(part)
			part.Close()

		case regexCardFront.MatchString(name):
			var bytesImg []byte
			bytesImg, err = ioutil.ReadAll(part)
			part.Close()

			cardFrontImages = append(cardFrontImages, bytesImg)

		case regexCardBack.MatchString(name):
			var bytesImg []byte
			bytesImg, err = ioutil.ReadAll(part)
			part.Close()

			cardBackImages = append(cardBackImages, bytesImg)
		}

		if err != nil {
			fmt.Println("vish aqui")
			return nil, nil, nil, nil, err
		}
	}

	return &deck, deckCover, cardFrontImages, cardBackImages, nil
}