package interfaces

import (
	"server/src/models"
	"server/src/errors"
)

type UserRepository interface {
	Create(user *models.User) *errors.RepositoryError
	Read(uuid string) (*models.User, *errors.RepositoryError)
	UpdateDecks(uuid string, decks []string) *errors.RepositoryError
	Delete(uuid string) *errors.RepositoryError
} 
