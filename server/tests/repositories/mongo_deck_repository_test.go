package repositories_tests

import (
	"server/src/models"
	"testing"

	"github.com/stretchr/testify/assert"
)

var newDeck = models.Deck{
	Name:             "Test Deck",
	Cards:            []models.Card{},
	LastModification: 1654638124,
	IsPublic:         false,
	UUID:             "testId",
}

func TestCreateDeck(t *testing.T) {
	_, err := deckRepository.InsertOrUpdate(&newDeck)

	assert.Nil(t, err)
}

func TestReadDeck(t *testing.T) {
	deck, err := deckRepository.Read(newDeck.UUID)

	assert.Nil(t, err)
	assert.Equal(t, newDeck.UUID, deck.UUID)
}

func TestUpdateDeck(t *testing.T) {
	newName := "Updated Deck"
	updatedDeck := newDeck
	updatedDeck.Name = newName

	deck, err := deckRepository.InsertOrUpdate(&updatedDeck)

	assert.Nil(t, err)
	assert.Equal(t, newName, deck.Name)
}

func TestDeleteDeck(t *testing.T) {
	err := deckRepository.Delete(newDeck.UUID)

	assert.Nil(t, err)
}
