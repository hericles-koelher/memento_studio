package models

type User struct {
	Decks		   []string 	`bson:"decks,omitempty"`		// ids dos baralhos
	UUID           string	`bson:"_id"`
}