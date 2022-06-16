package repositories

import (
	"context"
	"fmt"
	ms_errors "server/src/errors"
	"server/src/models"
	"server/src/repositories/interfaces"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
)

type MongoUserRepository struct {
	collection *mongo.Collection
}

func NewMongoUserRepository(collection *mongo.Collection) interfaces.UserRepository {
	repository := new(MongoUserRepository)

	repository.collection = collection

	return repository
}

func (repository MongoUserRepository) Create(user *models.User) *ms_errors.RepositoryError {
	_, err := repository.collection.InsertOne(
		context.TODO(),
		user,
	)

	if err != nil {
		if mongo.IsDuplicateKeyError(err) {
			return &ms_errors.RepositoryError{
				Message: fmt.Sprintf("A chave %s já existe em nossa coleção.", user.UUID),
				Code:    ms_errors.DuplicateKey,
			}
		} else if mongo.IsNetworkError(err) {
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
	}

	return nil
}

func (repository MongoUserRepository) Read(uuid string) (*models.User, *ms_errors.RepositoryError) {
	user := new(models.User)

	err := repository.collection.FindOne(
		context.TODO(),
		bson.M{"_id": uuid},
	).Decode(user)

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
	}

	return user, nil
}

func (repository MongoUserRepository) UpdateDecks(uuid string, decks []string) *ms_errors.RepositoryError {
	queryUpdate := bson.M{"$set": bson.M{"decks": decks}}

	_, err := repository.collection.UpdateOne(
		context.TODO(),
		bson.M{"_id": uuid},
		queryUpdate,
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
	}

	return nil
}

func (repository MongoUserRepository) Delete(uuid string) *ms_errors.RepositoryError {
	_, err := repository.collection.DeleteOne(
		context.TODO(),
		bson.M{"_id": uuid},
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
	}

	return nil
}
