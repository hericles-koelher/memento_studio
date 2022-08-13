package interfaces

import (
	"server/src/errors"
	"server/src/models"
)

// Interface do repositório de usuário
type UserRepository interface {
	Create(user *models.User) *errors.RepositoryError
	Read(uuid string) (*models.User, *errors.RepositoryError)
	UpdateDecks(uuid string, decks []string) *errors.RepositoryError
	Delete(uuid string) *errors.RepositoryError
}
