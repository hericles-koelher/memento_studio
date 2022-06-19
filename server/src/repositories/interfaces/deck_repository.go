package interfaces

import (
	"server/src/models"
	"server/src/errors"
)

type DeckRepository interface {
	Delete(uuid string) *errors.RepositoryError
	InsertOrUpdate(deck *models.Deck) (*models.Deck, bool, *errors.RepositoryError)
	Read(uuid string) (*models.Deck, *errors.RepositoryError)
	ReadAll(uuids []string, limit, page int) ([]models.Deck, *errors.RepositoryError)
}
