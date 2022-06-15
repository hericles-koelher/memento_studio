package repositories

import (
	memento_studio_errors "server/src/errors"
	"server/src/models"
)

type UserRepository interface {
	Create(user *models.User) *memento_studio_errors.RepositoryError
	Read(uuid string) (*models.User, *memento_studio_errors.RepositoryError)
	UpdateDecks(uuid string, decks []string) *memento_studio_errors.RepositoryError
	Delete(uuid string) *memento_studio_errors.RepositoryError
}
