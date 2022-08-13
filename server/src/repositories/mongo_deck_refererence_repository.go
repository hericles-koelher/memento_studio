package repositories

import (
	"context"
	"fmt"

	"server/src/errors"
	"server/src/models"
	"server/src/repositories/interfaces"
	"server/src/repositories/mongoutils"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

// Repositório de referência de baralho. Contém uma coleção do mongo.
type MongoDeckReferenceRepository struct {
	// Só pode ser acessado pelo pacote, pois começa com letra minuscula.
	coll *mongo.Collection
}

// Gera um novo 'MongoDeckReferenceRepository' a partir de uma coleção do mongo. O repositório implementa
// a interface 'DeckReferenceRepository'.
func NewMongoDeckReferenceRepository(collection *mongo.Collection) interfaces.DeckReferenceRepository {
	repository := new(MongoDeckReferenceRepository)

	repository.coll = collection

	return repository
}

// Deleta uma referência de baralho do banco de dados a partir um id de baralho.
// Retorna um 'RepositoryError', que pode ser nil.
func (repository MongoDeckReferenceRepository) Delete(uuid string) *errors.RepositoryError {
	_, err := repository.coll.DeleteOne(
		context.TODO(),
		bson.M{"_id": uuid},
	)

	if err != nil {
		fmt.Println("Erro ao deletar referencia do baralho...")

		return mongoutils.HandleError(err)
	} else {
		return nil
	}
}

// Insere ou atualiza uma referência de baralho a partir de uma instância do tipo 'DeckReference'.
// Retorna a referência criada ou atualizada, além de um booleano indicando se foi atualizado e um 'RepositoryError' que pode ser nil.
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

// Lê uma referência de baralho do banco de dados a partir de um id de baralho.
// Retorna a referência de baralho recuperada do banco e um 'RepositoryError' que pode ser nil.
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

// Retorna uma lista de referências de baralho dado um limite, uma página e um filtro, respectivamente.
// Além disso, retorna um 'RepositoryError' que pode ser nil.
func (repository MongoDeckReferenceRepository) ReadAll(limit, page int, filter interface{}) ([]models.DeckReference, *errors.RepositoryError) {
	result := []models.DeckReference{}

	cursor, err := repository.coll.Find(
		context.TODO(),
		filter,
		mongoutils.NewMongoPaginate(limit, page).GetPaginatedOpts(),
	)

	if err != nil {
		return nil, mongoutils.HandleError(err)
	}

	for cursor.Next(context.TODO()) {
		var deckRef models.DeckReference
		if err := cursor.Decode(&deckRef); err != nil {
			fmt.Println("Erro de leitura...")

			return nil, mongoutils.HandleError(err)
		}

		result = append(result, deckRef)
	}

	return result, nil
}
