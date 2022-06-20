package repositories_mock

import (
	"server/src/models"
	"server/src/repositories/interfaces"
	ms_errors "server/src/errors"
)

type DeckRepositoryMock struct {
	// Colocar aqui alguma variavel de controle, por exemplo se devia falhar com erro X
}

func NewDeckRepositoryMock() interfaces.DeckRepository {
	repository := new(DeckRepositoryMock)

	return repository
}

func (repository DeckRepositoryMock) Delete(uuid string) *ms_errors.RepositoryError {
	return nil
}

func (repository DeckRepositoryMock) InsertOrUpdate(deck *models.Deck) (*models.Deck, bool, *ms_errors.RepositoryError) {
	return deck, true, nil
}

func (repository DeckRepositoryMock) Read(uuid string) (*models.Deck, *ms_errors.RepositoryError) {
	return &models.Deck{
		Name:             "Test Deck",
		Cards:            []models.Card{},
		LastModification: 1654638124,
		IsPublic:         false,
		UUID:             uuid,
	}, nil
}

func (repository DeckRepositoryMock) ReadAll(uuids []string, limit, page int) ([]models.Deck, *ms_errors.RepositoryError) {
	var decks []models.Deck

	for _, id:= range(uuids) {
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