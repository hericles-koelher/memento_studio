package repositories_mock

import (
	"server/src/errors"
	"server/src/models"
	"server/src/repositories/interfaces"
)

// Repositório de referência de baralho usado nos testes.
type DeckReferenceRepositoryMock struct {
	DeckReferences []models.DeckReference
}

// Cria nova instância de 'DeckReferenceRepositoryMock'. Implementa a interface 'DeckReferenceRepository'.
func NewDeckReferenceRepositoryMock() interfaces.DeckReferenceRepository {
	repository := new(DeckReferenceRepositoryMock)
	repository.DeckReferences = []models.DeckReference{}

	return repository
}

// Função que simula a deleção de uma referência de baralho.
func (repository DeckReferenceRepositoryMock) Delete(uuid string) *errors.RepositoryError {
	return nil
}

// Função que simula a inserção ou atualização de uma referência de baralho.
func (repository DeckReferenceRepositoryMock) InsertOrUpdate(deckReference *models.DeckReference) (*models.DeckReference, bool, *errors.RepositoryError) {
	return nil, true, nil
}

// Função que simula a leitura de uma referência de baralho.
func (repository DeckReferenceRepositoryMock) Read(uuid string) (*models.DeckReference, *errors.RepositoryError) {
	return nil, nil
}

// Função que simula a leitura de uma lista de referência de baralho.
func (repository DeckReferenceRepositoryMock) ReadAll(limit int, offset int, filter interface{}) ([]models.DeckReference, *errors.RepositoryError) {
	return repository.DeckReferences, nil
}
