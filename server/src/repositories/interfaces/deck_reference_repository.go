package interfaces

import "server/src/models"

type DeckReferenceRepository interface {
	Delete(uuid string) error
	InsertOrUpdate(deck *models.DeckReference) (*models.DeckReference, bool, error)
	Read(uuid string) (*models.DeckReference, error)
	ReadAll(limit int, offset int, filter interface{}) ([]models.DeckReference, error)
}
