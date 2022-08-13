package repositories

import (
	"context"
	"fmt"

	ms_errors "server/src/errors"
	"server/src/models"
	"server/src/repositories/interfaces"
	"server/src/repositories/mongoutils"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

// Repositório de de baralho. Contém uma coleção do mongo.
type MongoDeckRepository struct {
	// Só pode ser acessado pelo pacote, pois começa com letra minuscula.
	coll *mongo.Collection
}

// Gera um novo 'MongoDeckRepository' a partir de uma coleção do mongo. O repositório implementa
// a interface 'DeckRepository'.
func NewMongoDeckRepository(collection *mongo.Collection) interfaces.DeckRepository {
	repository := new(MongoDeckRepository)

	repository.coll = collection

	return repository
}

// Deleta um baralho do banco de dados a partir um id de baralho.
// Retorna um 'RepositoryError', que pode ser nil.
func (repository *MongoDeckRepository) Delete(uuid string) *ms_errors.RepositoryError {
	_, err := repository.coll.DeleteOne(
		context.TODO(),
		bson.M{"_id": uuid},
	)

	return mongoutils.HandleError(err)
}

// Insere ou atualiza um baralho a partir de uma instância do tipo 'Deck'.
// Retorna o baralho criado ou atualizado, além de um booleano indicando se foi atualizado e um 'RepositoryError' que pode ser nil.
func (repository MongoDeckRepository) InsertOrUpdate(deck *models.Deck) (*models.Deck, bool, *ms_errors.RepositoryError) {
	// Flag que indica que caso o baralho não exista, então ele será inserido...
	upsert := true

	updateResult, err := repository.coll.UpdateOne(
		context.TODO(),
		bson.M{"_id": deck.UUID},
		bson.M{"$set": deck},
		&options.UpdateOptions{Upsert: &upsert},
	)

	return deck, updateResult.MatchedCount == 0, mongoutils.HandleError(err)
}

// Lê um baralho do banco de dados a partir de um id de baralho.
// Retorna o baralho recuperada do banco e um 'RepositoryError', que pode ser nil.
func (repository MongoDeckRepository) Read(uuid string) (*models.Deck, *ms_errors.RepositoryError) {
	result := new(models.Deck)

	err := repository.coll.FindOne(
		context.TODO(),
		bson.M{"_id": uuid},
	).Decode(result)

	return result, mongoutils.HandleError(err)
}

// Retorna uma lista de baralhos dado uma lista de ids, limite e uma página, respectivamente.
// Além disso, retorna um 'RepositoryError', que pode ser nil.
func (repository MongoDeckRepository) ReadAll(uuids []string, limit, page int) ([]models.Deck, *ms_errors.RepositoryError) {
	result := make([]models.Deck, 0)

	filter := bson.M{"_id": bson.M{"$in": uuids}}
	cursor, err := repository.coll.Find(
		context.TODO(),
		filter,
		mongoutils.NewMongoPaginate(limit, page).GetPaginatedOpts())

	if err != nil {
		return result, mongoutils.HandleError(err)
	}

	for cursor.Next(context.TODO()) {
		var deck models.Deck
		if err := cursor.Decode(&deck); err != nil {
			fmt.Println("Erro de leitura...")

			return nil, mongoutils.HandleError(err)
		}

		result = append(result, deck)
	}

	return result, nil
}
