package repositories_mock

import (
	ms_errors "server/src/errors"
	"server/src/models"
	"server/src/repositories/interfaces"
)

// Repositório de baralho usado nos testes.
type DeckRepositoryMock struct {
	Decks map[string]*models.Deck
}

// Cria nova instância de 'DeckRepositoryMock'. Implementa a interface 'DeckRepository'.
func NewDeckRepositoryMock() interfaces.DeckRepository {
	repository := new(DeckRepositoryMock)
	repository.Decks = map[string]*models.Deck{}

	return repository
}

// Função que simula a deleção de um baralho.
func (repository DeckRepositoryMock) Delete(uuid string) *ms_errors.RepositoryError {
	return nil
}

// Função que simula a inserção ou atualização de um baralho.
func (repository DeckRepositoryMock) InsertOrUpdate(deck *models.Deck) (*models.Deck, bool, *ms_errors.RepositoryError) {
	repository.Decks[deck.UUID] = deck
	return deck, true, nil
}

// Função que simula a leitura de um baralho.
func (repository DeckRepositoryMock) Read(uuid string) (*models.Deck, *ms_errors.RepositoryError) {
	return repository.Decks[uuid], nil
}

// Função que simula a leitura de uma lista de baralho.
func (repository DeckRepositoryMock) ReadAll(uuids []string, limit, page int) ([]models.Deck, *ms_errors.RepositoryError) {
	var decks []models.Deck

	for _, id := range uuids {
		newDeck := models.Deck{
			Name:             "Test Deck",
			Cards:            []models.Card{},
			LastModification: 1654638124,
			IsPublic:         false,
			UUID:             id,
		}

		decks = append(decks, newDeck)
	}

	return decks, nil
}
