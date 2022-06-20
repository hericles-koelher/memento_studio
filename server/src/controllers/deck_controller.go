package controllers

import (
	"net/http"
	"fmt"

	. "server/src/repositories/interfaces"
	"server/src/utils"
	"server/src/models"
	"server/src/errors"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

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
		context.JSON(http.StatusInternalServerError, gin.H{"message": "Could not post decks"})
		return
	}

	// Get user
	user := getUser(context, userRepository)
	if user == nil { return }
	
	// Get decks in requisition's body
	var decksReq = []models.Deck{}
	if err := context.BindJSON(&decksReq); err!=nil {
		context.JSON(http.StatusBadRequest, gin.H{"message": "Could not post decks"})
		return
	 }
	
	var deckIds = user.Decks
	for _,deck := range(decksReq) {
		// Insert or update deck
		if deck.UUID == "" {
			deck.UUID = uuid.New().String()
		}
		_, _, err := deckRepository.InsertOrUpdate(&deck)
		if err != nil {
			context.JSON(http.StatusInternalServerError, gin.H{"message": "Could not post decks"})
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

			_, _, err := deckReferenceRepository.InsertOrUpdate(deckReference)
			if err != nil {
				context.JSON(http.StatusInternalServerError, gin.H{"message": "Could not post decks"})
				return
			}
		}

		// Update user's decks ids
		if !utils.Contains(deckIds, deck.UUID, 
			func (id1, id2 interface{}) bool {
				return id1.(string) == id2.(string)
			}) {
			deckIds = append(deckIds, deck.UUID)
		}
	}

	// Update user decks
	errRepo := userRepository.UpdateDecks(user.UUID, deckIds)
	if errRepo != nil {
		context.JSON(handleRepositoryError(errRepo), errRepo.Error())
		return
	}

	context.JSON(http.StatusOK, gin.H{"userDecks": deckIds})
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
	limit, okLim := reqBody["limit"].(float64)
	page, okPage := reqBody["page"].(float64)
	if !okLim || !okPage {
		context.JSON(http.StatusBadRequest, "Limite e página devem ser um número")
		return
	}

	decksResult, errRepo := deckRepository.ReadAll(user.Decks, (int)(limit), (int)(page))
	if err != nil {
		context.JSON(handleRepositoryError(errRepo), errRepo.Error())
		return
	}
	
	context.JSON(http.StatusOK, decksResult)
}


// Aux functions

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