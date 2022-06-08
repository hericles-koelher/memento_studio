package repositories

import (
	"context"
	"fmt"
	"server/src/models"

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

func NewMongoDeckRepository(collection *mongo.Collection) *MongoDeckRepository {
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

func (repository MongoDeckRepository) InsertOrUpdate(deck *models.Deck) (*models.Deck, error) {
	// Flag que indica que caso o baralho não exista, então ele será inserido...
	upsert := true

	_, err := repository.coll.UpdateOne(
		context.TODO(),
		bson.M{"_id": deck.UUID},
		bson.M{"$set": deck},
		&options.UpdateOptions{Upsert: &upsert},
	)

	if err != nil {
		fmt.Println("Erro de inserção...")

		return nil, err
	} else {
		return deck, nil
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
