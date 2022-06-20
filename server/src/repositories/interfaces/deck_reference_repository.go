package interfaces

import (
	"server/src/models"
	"server/src/errors"
)

type DeckReferenceRepository interface {
	Delete(uuid string) *errors.RepositoryError
	InsertOrUpdate(deck *models.DeckReference) (*models.DeckReference, bool, *errors.RepositoryError)
	Read(uuid string) (*models.DeckReference, *errors.RepositoryError)
	ReadAll(limit int, min int, max int, filter interface{}) ([]models.DeckReference, *errors.RepositoryError)
}
