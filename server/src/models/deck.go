package models

type Deck struct {
	Cards            []Card   `json:"cards" bson:"cards,omitempty"`
	Cover            string   `json:"cover" bson:"cover,omitempty"`
	Description      string   `json:"description" bson:"description,omitempty"`
	IsPublic         bool     `json:"isPublic" bson:"isPublic,omitempty"`
	LastModification int64    `json:"lastModification" bson:"lastModification,omitempty"`
	Name             string   `json:"name" bson:"name,omitempty"`
	Tags             []string `json:"tags" bson:"tags, omitempty"`
	UUID             string   `bson:"_id"`
}
