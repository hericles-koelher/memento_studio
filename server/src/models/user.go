package models

type User struct {
	Decks               []string `bson:"decks,omitempty"` // ids dos baralhos
	LastSynchronization int64    `bson:"lastSynchronization,omitempty"`
	UUID                string   `bson:"_id"`
}
