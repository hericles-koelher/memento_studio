package models

type Deck struct {
	Name             string `bson:"name,omitempty"`
	Cards            []Card `bson:"cards,omitempty,inline"`
	LastModification int64  `bson:"lastModification,omitempty"`
	IsPublic         bool   `bson:"isPublic,omitempty"`
	UUID             string `bson:"_id"`
}
