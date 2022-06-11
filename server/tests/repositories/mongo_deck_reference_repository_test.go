package repositories_tests

import (
	"server/src/models"
	"testing"

	"github.com/stretchr/testify/assert"
	"go.mongodb.org/mongo-driver/bson"
)

var newDeckReference = models.DeckReference{
	Name:          "Test Deck",
	UUID:          "testId",
	Description:   "test desc",
	NumberOfCards: 0,
}

func TestCreateDeckReference(t *testing.T) {
	_, err := deckReferenceRepository.InsertOrUpdate(&newDeckReference)

	assert.Nil(t, err)
}

func TestReadDeckReference(t *testing.T) {
	deck, err := deckReferenceRepository.Read(newDeckReference.UUID)

	assert.Nil(t, err)
	assert.Equal(t, newDeckReference.UUID, deck.UUID)
}

func TestSearchDeckReference(t *testing.T) {
	deck, err := deckReferenceRepository.Search(bson.M{"_id": newDeckReference.UUID})

	assert.Nil(t, err)
	assert.Equal(t, newDeckReference.UUID, deck.UUID)
}

func TestUpdateDeckReference(t *testing.T) {
	newName := "Updated Deck"
	updatedDeck := newDeckReference
	updatedDeck.Name = newName

	deck, err := deckReferenceRepository.InsertOrUpdate(&updatedDeck)

	assert.Nil(t, err)
	assert.Equal(t, newName, deck.Name)
}

func TestDeleteDeckReference(t *testing.T) {
	err := deckReferenceRepository.Delete(newDeckReference.UUID)

	assert.Nil(t, err)
}
