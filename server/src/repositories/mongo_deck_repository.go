package repositories

import (
	"context"
	"fmt"
	"server/src/models"
	"time"

	"github.com/google/uuid"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
)

type MongoDeckRepository struct {
	// Só pode ser acessado pelo pacote, pois começa com
	// letra minuscula.
	deckCollection *mongo.Collection
}

func NewMongoDeckRepository(collection *mongo.Collection) *MongoDeckRepository {
	repository := new(MongoDeckRepository)

	repository.deckCollection = collection

	return repository
}

func (repository MongoDeckRepository) Create() (*models.Deck, error) {
	deckUuid := uuid.New()

	fmt.Println("Generated UUID = " + deckUuid.String())

	deck := &models.Deck{
		UUID:             deckUuid.String(),
		LastModification: time.Now().UnixMilli(),
		IsPublic:         false,
	}

	// TODO: pesquisar o funcionamento desse context
	context, _ := context.WithTimeout(context.Background(), 15*time.Second)

	_, insertErr := repository.deckCollection.InsertOne(context, deck)

	// TODO: melhorar essa parte aqui...
	if insertErr != nil {
		fmt.Println("Erro de inserção...")

		return nil, insertErr
	}

	return deck, nil
}

func (repository MongoDeckRepository) Read(uuid string) (*models.Deck, error) {
	// TODO: retornar baralho com o uuid especificado.
}

func (repository MongoDeckRepository) Update(deck map[string]interface{}) (*models.Deck, error) {
	// TODO: atualizar baralho com o uuid especificado.
}

func (repository MongoDeckRepository) Delete(uuid string) error {
	// TODO: deletar baralho com o uuid especificado.
	// TODO: pesquisar o funcionamento desse context
	context, _ := context.WithTimeout(context.Background(), 15*time.Second)

	_, err := repository.deckCollection.DeleteOne(context, bson.M{"UUID": uuid})

	if err != nil {
		fmt.Println("Erro ao deletar baralho...")

		return err
	}
}
