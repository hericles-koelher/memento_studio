package repositories

import "server/src/models"

type DeckReferenceRepository interface {
	Delete(uuid string) error
	InsertOrUpdate(deck *models.DeckReference) (*models.DeckReference, error)
	Read(uuid string) (*models.DeckReference, error)
}
