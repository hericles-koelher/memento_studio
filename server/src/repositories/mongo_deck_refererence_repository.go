package repositories

import (
	"context"
	"fmt"

	"server/src/models"
	"server/src/errors"
	"server/src/repositories/mongoutils"
	"server/src/repositories/interfaces"

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

func NewMongoDeckReferenceRepository(collection *mongo.Collection) interfaces.DeckReferenceRepository {
	repository := new(MongoDeckReferenceRepository)

	repository.coll = collection

	return repository
}

func (repository MongoDeckReferenceRepository) Delete(uuid string) *errors.RepositoryError {
	_, err := repository.coll.DeleteOne(
		context.TODO(),
		bson.M{"UUID": uuid},
	)

	if err != nil {
		fmt.Println("Erro ao deletar referencia do baralho...")

		return mongoutils.HandleError(err)
	} else {
		return nil
	}
}

func (repository MongoDeckReferenceRepository) InsertOrUpdate(deckReference *models.DeckReference) (*models.DeckReference, bool, *errors.RepositoryError) {
	// Flag que indica que caso o baralho não exista, então ele será inserido...
	upsert := true

	updateResult, err := repository.coll.UpdateOne(
		context.TODO(),
		bson.M{"_id": deckReference.UUID},
		bson.M{"$set": deckReference},
		&options.UpdateOptions{Upsert: &upsert},
	)

	if err != nil {
		fmt.Println("Erro de inserção...")

		return nil, false, mongoutils.HandleError(err)
	} else {
		return deckReference, updateResult.MatchedCount == 0, nil
	}
}

func (repository MongoDeckReferenceRepository) Read(uuid string) (*models.DeckReference, *errors.RepositoryError) {
	result := new(models.DeckReference)

	err := repository.coll.FindOne(
		context.TODO(),
		bson.M{"_id": uuid},
	).Decode(result)

	if err != nil {
		return nil, mongoutils.HandleError(err)
	} else {
		return result, nil
	}
}

func (repository MongoDeckReferenceRepository) ReadAll(limit int, offset int, filter interface{}) ([]models.DeckReference, *errors.RepositoryError) {
	result := []models.DeckReference{}

	cursor, err := repository.coll.Find(
		context.TODO(),
		filter,
		options.Find().SetLimit(int64(limit)).SetSkip(int64(offset)),
	)

	if err != nil {
		return nil, mongoutils.HandleError(err)
	} else {
		cursor.Decode(&result)

		return result, nil
	}
}
