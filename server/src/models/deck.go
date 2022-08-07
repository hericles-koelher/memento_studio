package models

type Deck struct {
	Cards            []Card   `json:"cards" bson:"cards"`
	Cover            string   `json:"cover" bson:"cover"`
	Description      string   `json:"description" bson:"description"`
	IsPublic         bool     `json:"isPublic" bson:"isPublic"`
	LastModification int64    `json:"lastModification" bson:"lastModification"`
	Name             string   `json:"name" bson:"name"`
	Tags             []string `json:"tags" bson:"tags"`
	UUID             string   `json:"UUID" bson:"_id"`
}
