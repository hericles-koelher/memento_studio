package repositories

import (
	"context"
	"fmt"
	"server/src/models"
	"server/src/repositories/interfaces"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

// TODO: Mudar o uso de context nesse arquivo. Devemos conversar sobre isso depois...

// TODO: Melhorar todos os tratamentos de erro.

type MongoDeckRepository struct {
	// Só pode ser acessado pelo pacote, pois começa com letra minuscula.
	coll *mongo.Collection
}

func NewMongoDeckRepository(collection *mongo.Collection) interfaces.DeckRepository {
	repository := new(MongoDeckRepository)

	repository.coll = collection

	return repository
}

func (repository MongoDeckRepository) Delete(uuid string) error {
	_, err := repository.coll.DeleteOne(
		context.TODO(),
		bson.M{"UUID": uuid},
	)

	if err != nil {
		fmt.Println("Erro ao deletar baralho...")

		return err
	} else {
		return nil
	}
}

func (repository MongoDeckRepository) InsertOrUpdate(deck *models.Deck) (*models.Deck, bool, error) {
	// Flag que indica que caso o baralho não exista, então ele será inserido...
	upsert := true

	updateResult, err := repository.coll.UpdateOne(
		context.TODO(),
		bson.M{"_id": deck.UUID},
		bson.M{"$set": deck},
		&options.UpdateOptions{Upsert: &upsert},
	)

	if err != nil {
		fmt.Println("Erro de inserção...")

		return nil, false, err
	} else {
		return deck, updateResult.MatchedCount == 0, nil
	}
}

func (repository MongoDeckRepository) Read(uuid string) (*models.Deck, error) {
	result := new(models.Deck)

	err := repository.coll.FindOne(
		context.TODO(),
		bson.M{"_id": uuid},
	).Decode(result)

	if err != nil {
		fmt.Println("Erro de leitura...")

		return nil, err
	} else {
		return result, nil
	}
}
