package models

type DeckReference struct {
	Cover         string   `bson:"cover,omitempty"`
	Description   string   `bson:"description, omitempty"`
	Name          string   `bson:"name,omitempty"`
	NumberOfCards int      `bson:"numberOfCards, omitempty"`
	Tags          []string `bson:"tags, omitempty"`
	Author        string   `bson:"author"`
	UUID          string   `bson:"_id"`
}
