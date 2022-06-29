package repositories_mock

import (
	"server/src/errors"
	"server/src/models"
	"server/src/repositories/interfaces"
)

type DeckReferenceRepositoryMock struct {
	DeckReferences		[]models.DeckReference
}

func NewDeckReferenceRepositoryMock() interfaces.DeckReferenceRepository {
	repository := new(DeckReferenceRepositoryMock)
	repository.DeckReferences = []models.DeckReference{}

	return repository
}

func (repository DeckReferenceRepositoryMock) Delete(uuid string) *errors.RepositoryError {
	return nil
}

func (repository DeckReferenceRepositoryMock) InsertOrUpdate(deckReference *models.DeckReference) (*models.DeckReference, bool, *errors.RepositoryError) {
	return nil, true, nil
}

func (repository DeckReferenceRepositoryMock) Read(uuid string) (*models.DeckReference, *errors.RepositoryError) {
	return nil, nil
}

func (repository DeckReferenceRepositoryMock) ReadAll(limit int, offset int, filter interface{}) ([]models.DeckReference, *errors.RepositoryError) {
	return repository.DeckReferences, nil
}
