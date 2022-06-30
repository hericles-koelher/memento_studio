package repositories_mock

import (
	"server/src/models"
	"server/src/repositories/interfaces"
	ms_errors "server/src/errors"
)

type DeckRepositoryMock struct {
	Decks map[string]*models.Deck
}

func NewDeckRepositoryMock() interfaces.DeckRepository {
	repository := new(DeckRepositoryMock)
	repository.Decks = map[string]*models.Deck{}

	return repository
}

func (repository DeckRepositoryMock) Delete(uuid string) *ms_errors.RepositoryError {
	return nil
}

func (repository DeckRepositoryMock) InsertOrUpdate(deck *models.Deck) (*models.Deck, bool, *ms_errors.RepositoryError) {
	repository.Decks[deck.UUID] = deck
	return deck, true, nil
}

func (repository DeckRepositoryMock) Read(uuid string) (*models.Deck, *ms_errors.RepositoryError) {
	return repository.Decks[uuid], nil
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