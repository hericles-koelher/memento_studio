package repositories

import (
	"context"
	"fmt"
	ms_errors "server/src/errors"
	"server/src/models"
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

func (repository MongoDeckReferenceRepository) Delete(uuid string) error {
	_, err := repository.coll.DeleteOne(
		context.TODO(),
		bson.M{"UUID": uuid},
	)

	if err != nil {
		if mongo.IsNetworkError(err) {
			return &ms_errors.RepositoryError{
				Message: fmt.Sprintf("Erro de conexão com a base de dados.\n\n%s", err.Error()),
				Code:    ms_errors.NetworkError,
			}
		} else if mongo.IsTimeout(err) {
			return &ms_errors.RepositoryError{
				Message: "Tempo esgotado.",
				Code:    ms_errors.Timeout,
			}
		} else {
			return &ms_errors.RepositoryError{
				Message: fmt.Sprintf("Erro desconhecido: %s", err.Error()),
				Code:    ms_errors.Unkown,
			}
		}
	} else {
		return nil
	}
}

func (repository MongoDeckReferenceRepository) InsertOrUpdate(deckReference *models.DeckReference) (*models.DeckReference, bool, error) {
	// Flag que indica que caso o baralho não exista, então ele será inserido...
	upsert := true

	updateResult, err := repository.coll.UpdateOne(
		context.TODO(),
		bson.M{"_id": deckReference.UUID},
		bson.M{"$set": deckReference},
		&options.UpdateOptions{Upsert: &upsert},
	)

	if err != nil {
		if mongo.IsNetworkError(err) {
			return nil, false, &ms_errors.RepositoryError{
				Message: fmt.Sprintf("Erro de conexão com a base de dados.\n\n%s", err.Error()),
				Code:    ms_errors.NetworkError,
			}
		} else if mongo.IsTimeout(err) {
			return nil, false, &ms_errors.RepositoryError{
				Message: "Tempo esgotado.",
				Code:    ms_errors.Timeout,
			}
		} else {
			return nil, false, &ms_errors.RepositoryError{
				Message: fmt.Sprintf("Erro desconhecido: %s", err.Error()),
				Code:    ms_errors.Unkown,
			}
		}
	} else {
		return deckReference, updateResult.MatchedCount == 0, nil
	}
}

func (repository MongoDeckReferenceRepository) Read(uuid string) (*models.DeckReference, error) {
	result := new(models.DeckReference)

	err := repository.coll.FindOne(
		context.TODO(),
		bson.M{"_id": uuid},
	).Decode(result)

	if err != nil {
		if mongo.IsNetworkError(err) {
			return nil, &ms_errors.RepositoryError{
				Message: fmt.Sprintf("Erro de conexão com a base de dados.\n\n%s", err.Error()),
				Code:    ms_errors.NetworkError,
			}
		} else if mongo.IsTimeout(err) {
			return nil, &ms_errors.RepositoryError{
				Message: "Tempo esgotado.",
				Code:    ms_errors.Timeout,
			}
		} else {
			return nil, &ms_errors.RepositoryError{
				Message: fmt.Sprintf("Erro desconhecido: %s", err.Error()),
				Code:    ms_errors.Unkown,
			}
		}
	} else {
		return result, nil
	}
}

func (repository MongoDeckReferenceRepository) ReadAll(limit int, offset int, filter interface{}) ([]models.DeckReference, error) {
	result := []models.DeckReference{}

	cursor, err := repository.coll.Find(
		context.TODO(),
		filter,
		options.Find().SetLimit(int64(limit)).SetSkip(int64(offset)),
	)

	if err != nil {
		if mongo.IsNetworkError(err) {
			return nil, &ms_errors.RepositoryError{
				Message: fmt.Sprintf("Erro de conexão com a base de dados.\n\n%s", err.Error()),
				Code:    ms_errors.NetworkError,
			}
		} else if mongo.IsTimeout(err) {
			return nil, &ms_errors.RepositoryError{
				Message: "Tempo esgotado.",
				Code:    ms_errors.Timeout,
			}
		} else {
			return nil, &ms_errors.RepositoryError{
				Message: fmt.Sprintf("Erro desconhecido: %s", err.Error()),
				Code:    ms_errors.Unkown,
			}
		}
	} else {
		cursor.Decode(&result)

		return result, nil
	}
}
