package repositories_mock

import (
	ms_errors "server/src/errors"
	"server/src/models"
	"server/src/repositories/interfaces"
)

type UserRepositoryMock struct {
	// Colocar aqui alguma variavel de controle, por exemplo se devia falhar com erro X 
	// ou o que retornar exatamente
	user *models.User
}

func NewUserRepositoryMock(userId string, decks []string) interfaces.UserRepository {
	repository := new(UserRepositoryMock)
	repository.user =  &models.User{
		UUID: userId,
		Decks: decks,
	}

	return repository
}

func (repository UserRepositoryMock) Create(user *models.User) *ms_errors.RepositoryError {
	return nil
}

func (repository UserRepositoryMock) Read(uuid string) (*models.User, *ms_errors.RepositoryError) {
	return repository.user, nil
}

func (repository UserRepositoryMock) UpdateDecks(uuid string, decks []string) *ms_errors.RepositoryError {
	return nil
}

func (repository UserRepositoryMock) Delete(uuid string) *ms_errors.RepositoryError {
	return nil
}

