package repositories

import (
	"context"
	"fmt"
	"server/src/models"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
)

type MongoUserRepository struct {
	collection *mongo.Collection
}

func NewMongoUserRepository(collection *mongo.Collection) *MongoUserRepository {
	repository := new(MongoUserRepository)
	repository.collection = collection

	return repository
}

func (repository MongoUserRepository) Create(user *models.User) error {
	_, err := repository.collection.InsertOne(
		context.TODO(),
		user,
	)

	// TODO: Tratar erro melhor nesse e nos seguintes
	if err != nil {
		fmt.Println("Erro ao criar usuário...")
		return err
	}

	return nil
}

func (repository MongoUserRepository) Read(uuid string) (*models.User, error) {
	user := new(models.User)

	err := repository.collection.FindOne(
		context.TODO(),
		bson.M{"_id": uuid},
	).Decode(user)

	if err != nil {
		fmt.Println("Erro ao ler usuário...")
		return nil, err
	}

	return user, nil
}

func (repository MongoUserRepository) UpdateDecks(uuid string, decks []models.Deck) error {
	queryUpdate:= bson.M{"$set": bson.M{"decks": decks}}

	_, err := repository.collection.UpdateOne(
		context.TODO(),
		bson.M{"_id": uuid},
		queryUpdate,
	)

	if err != nil {
		fmt.Println("Erro ao atualizar baralhos de usuário...")
		return err
	}

	return nil
}

func (repository MongoUserRepository) Delete(uuid string) (int, error) {
	result, err := repository.collection.DeleteOne(
		context.TODO(),
		bson.M{"_id": uuid},
	)

	if err != nil {
		fmt.Println("Erro ao deletar usuário...")
		return 0 , err
	}

	return int(result.DeletedCount) , nil
}