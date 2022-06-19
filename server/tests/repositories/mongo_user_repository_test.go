package repositories_tests

import (
	"testing"
	"server/src/models"
	"github.com/stretchr/testify/assert"
)

const (
	userId = "niceuuid"
	deckId = "nicedeckuuid"
)


func TestCreateUser(t *testing.T) {
	newUser := new(models.User)
	newUser.Decks = []string{}
	newUser.UUID = userId

	err := userRepository.Create(newUser)

	assert.Nil(t, err)
}

func TestReadUser(t *testing.T) {
	user, err := userRepository.Read(userId)

	assert.Nil(t, err)
	assert.Equal(t, userId, user.UUID)
}

func TestUpdateDecks(t *testing.T) {
	err := userRepository.UpdateDecks(userId, []string{deckId})
	user, _ := userRepository.Read(userId)

	assert.Nil(t, err)
	assert.Equal(t, deckId, user.Decks[0])
}

func TestDeleteUser(t *testing.T) {
	err := userRepository.Delete(userId)

	assert.Nil(t, err)
}
