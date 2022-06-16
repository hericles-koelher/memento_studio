package interfaces

import "server/src/models"

type DeckRepository interface {
	Delete(uuid string) error
	InsertOrUpdate(deck *models.Deck) (*models.Deck, bool, error)
	Read(uuid string) (*models.Deck, error)
}
