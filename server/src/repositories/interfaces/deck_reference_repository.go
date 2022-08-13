package interfaces

import (
	"server/src/errors"
	"server/src/models"
)

// Interface do repositório de referência de baralho
type DeckReferenceRepository interface {
	Delete(uuid string) *errors.RepositoryError
	InsertOrUpdate(deck *models.DeckReference) (*models.DeckReference, bool, *errors.RepositoryError)
	Read(uuid string) (*models.DeckReference, *errors.RepositoryError)
	ReadAll(limit int, offset int, filter interface{}) ([]models.DeckReference, *errors.RepositoryError)
}
