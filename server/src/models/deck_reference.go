package models

// Referência de baralho. Criada quando um baralho é público, para ser acessada por outros usuários.
type DeckReference struct {
	Cover         string   `bson:"cover"`
	Description   string   `bson:"description"`
	Name          string   `bson:"name"`
	NumberOfCards int      `bson:"numberOfCards"`
	Tags          []string `bson:"tags"`
	Author        string   `bson:"author"`
	UUID          string   `bson:"_id"`
}
