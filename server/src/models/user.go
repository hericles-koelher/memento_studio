package models

type User struct {
	Decks		   []Deck 	`bson:"decks,omitempty"`		// ids dos baralhos
	UUID           string	`bson:"_id"`
}