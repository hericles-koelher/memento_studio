package models

type Card struct {
	FrontText      string `json:"frontText" bson:"frontText"`
	BackText       string `json:"backText" bson:"backText"`
	FrontImagePath string `json:"frontImagePath" bson:"frontImagePath"`
	BackImagePath  string `json:"backImagePath" bson:"backImagePath"`
	UUID           string `json:"uuid" bson:"uuid"`
}
