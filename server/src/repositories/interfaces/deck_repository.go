package interfaces

import (
	"server/src/errors"
	"server/src/models"
)

// Interface do respositório de baralho
type DeckRepository interface {
	Delete(uuid string) *errors.RepositoryError
	InsertOrUpdate(deck *models.Deck) (*models.Deck, bool, *errors.RepositoryError)
	Read(uuid string) (*models.Deck, *errors.RepositoryError)
	ReadAll(uuids []string, limit, page int) ([]models.Deck, *errors.RepositoryError)
}
