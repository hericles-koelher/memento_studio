package repositories

import "server/src/models"

type UserRepository interface {
	Create(user *models.User) error
	Read(uuid string) (*models.User, error)
	UpdateDecks(uuid string, decks []string) error
	Delete(uuid string) error
} 