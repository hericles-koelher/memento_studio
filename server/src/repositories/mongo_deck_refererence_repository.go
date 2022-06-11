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

type MongoDeckReferenceRepository struct {
	// Só pode ser acessado pelo pacote, pois começa com letra minuscula.
	coll *mongo.Collection
}

func NewMongoDeckReferenceRepository(collection *mongo.Collection) *MongoDeckReferenceRepository {
	repository := new(MongoDeckReferenceRepository)

	repository.coll = collection

	return repository
}

func (repository MongoDeckReferenceRepository) Delete(uuid string) error {
	_, err := repository.coll.DeleteOne(
		context.TODO(),
		bson.M{"UUID": uuid},
	)

	if err != nil {
		fmt.Println("Erro ao deletar referencia do baralho...")

		return err
	} else {
		return nil
	}
}

func (repository MongoDeckReferenceRepository) InsertOrUpdate(deckReference *models.DeckReference) (*models.DeckReference, error) {
	// Flag que indica que caso o baralho não exista, então ele será inserido...
	upsert := true

	_, err := repository.coll.UpdateOne(
		context.TODO(),
		bson.M{"_id": deckReference.UUID},
		bson.M{"$set": deckReference},
		&options.UpdateOptions{Upsert: &upsert},
	)

	if err != nil {
		fmt.Println("Erro de inserção...")

		return nil, err
	} else {
		return deckReference, nil
	}
}

func (repository MongoDeckReferenceRepository) Read(uuid string) (*models.DeckReference, error) {
	result := new(models.DeckReference)

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

func (repository MongoDeckReferenceRepository) Search(filter interface{}) (*models.DeckReference, error) {
	result := new(models.DeckReference)

	err := repository.coll.FindOne(
		context.TODO(),
		filter,
	).Decode(result)

	if err != nil {
		fmt.Println("Erro de leitura...")

		return nil, err
	} else {
		return result, nil
	}
}
