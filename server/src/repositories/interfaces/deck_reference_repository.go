package interfaces

import "server/src/models"

type DeckReferenceRepository interface {
	Delete(uuid string) error
	InsertOrUpdate(deck *models.DeckReference) (*models.DeckReference, bool, error)
	Read(uuid string) (*models.DeckReference, error)
	ReadAll(limit int, min int, max int, filter interface{}) ([]models.DeckReference, error)
}
