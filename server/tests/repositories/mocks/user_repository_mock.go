package repositories_mock

import (
	ms_errors "server/src/errors"
	"server/src/models"
	"server/src/repositories/interfaces"
)

// Repositório de usuário usado nos testes.
type UserRepositoryMock struct {
	// Colocar aqui alguma variavel de controle, por exemplo se devia falhar com erro X
	// ou o que retornar exatamente
	user *models.User
}

// Cria nova instância de 'UserRepositoryMock'. Implementa a interface 'UserRepository'.
func NewUserRepositoryMock(userId string, decks []string) interfaces.UserRepository {
	repository := new(UserRepositoryMock)
	repository.user = &models.User{
		UUID:  userId,
		Decks: decks,
	}

	return repository
}

// Função que simula o armazenamento de um novo usuário.
func (repository UserRepositoryMock) Create(user *models.User) *ms_errors.RepositoryError {
	return nil
}

// Função que simula a leitura de um usuário.
func (repository UserRepositoryMock) Read(uuid string) (*models.User, *ms_errors.RepositoryError) {
	return repository.user, nil
}

// Função que simula a atualização da lista de baralhos de um usuário.
func (repository UserRepositoryMock) UpdateDecks(uuid string, decks []string) *ms_errors.RepositoryError {
	return nil
}

// Função que simula a deleção de um usuário.
func (repository UserRepositoryMock) Delete(uuid string) *ms_errors.RepositoryError {
	return nil
}
