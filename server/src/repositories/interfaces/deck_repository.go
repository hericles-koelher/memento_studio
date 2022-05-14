package repositories

import "server/src/models"

type DeckRepository interface {
	Create() (*models.Deck, error)
	Read(uuid string) (*models.Deck, error)
	Update(deck map[string]interface{}) (*models.Deck, error)
	Delete(uuid string) error
}
