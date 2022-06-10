package models

type Deck struct {
	Cards            []Card `bson:"cards,omitempty"`
	Description      string `bson:"description,omitempty"`
	IsPublic         bool   `bson:"isPublic,omitempty"`
	LastModification int64  `bson:"lastModification,omitempty"`
	Name             string `bson:"name,omitempty"`
	UUID             string `bson:"_id"`
}
