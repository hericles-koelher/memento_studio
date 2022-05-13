package models

type Card struct {
	FrontText      string `bson:"frontText,omitempty"`
	BackText       string `bson:"backText,omitempty"`
	FrontImagePath string `bson:"frontImagePath,omitempty"`
	BackImagePath  string `bson:"backImagePath,omitempty"`
	UUID           string
}
