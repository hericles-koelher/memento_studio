package models

type DeckReference struct {
	Name          string `bson:"deckName,omitempty"`
	UUID          string `bson:"_id"`
	Description   string `bson:"description, omitempty"`
	NumberOfCards int    `bson:"numberOfCards, omitempty"`
}
