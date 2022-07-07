package repositories_tests

import (
	"server/src/models"
	"testing"
	"fmt"

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
	_, wasCreated, err := deckRepository.InsertOrUpdate(&newDeck)

	assert.Nil(t, err)
	assert.True(t, wasCreated)
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

	deck, wasCreated, err := deckRepository.InsertOrUpdate(&updatedDeck)

	assert.Nil(t, err)
	assert.False(t, wasCreated)
	assert.Equal(t, newName, deck.Name)
}

func TestDeleteDeck(t *testing.T) {
	err := deckRepository.Delete(newDeck.UUID)

	assert.Nil(t, err)
}

func TestReadAllDecks(t *testing.T) {
	// Add decks
	for i:=0; i <5; i++ {
		newDeck.UUID = fmt.Sprintf("deckid%d",i)
		deckRepository.InsertOrUpdate(&newDeck)
	}

	uuids := []string{"deckid0", "deckid1", "deckid2", "deckid3"}
	limit, page := 10, 1

	decks, err := deckRepository.ReadAll(uuids, limit, page)

	assert.Nil(t, err)
	assert.Equal(t, len(decks), len(uuids))
}
