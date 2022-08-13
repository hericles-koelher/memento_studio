package models

// Usuário
type User struct {
	Decks               []string `bson:"decks"` // ids dos baralhos
	LastSynchronization int64    `bson:"lastSynchronization,omitempty"`
	UUID                string   `bson:"_id"`
}
