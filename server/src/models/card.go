package models

type Card struct {
	FrontText      string `json:"frontText" bson:"frontText,omitempty"`
	BackText       string `json:"backText" bson:"backText,omitempty"`
	FrontImagePath string `json:"frontImagePath" bson:"frontImagePath,omitempty"`
	BackImagePath  string `json:"backImagePath" bson:"backImagePath,omitempty"`
	UUID           string
}
