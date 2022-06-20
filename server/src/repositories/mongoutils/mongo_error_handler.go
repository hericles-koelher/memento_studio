package mongoutils

import (
	"fmt"

	ms_errors "server/src/errors"

	"go.mongodb.org/mongo-driver/mongo"
)

func HandleError(err error) *ms_errors.RepositoryError {
	if err != nil {
		if mongo.IsDuplicateKeyError(err) {
			return &ms_errors.RepositoryError{
				Message: fmt.Sprintf("A chave já existe em nossa coleção."),
				Code:    ms_errors.DuplicateKey,
			}
		} else if mongo.IsNetworkError(err) {
			return &ms_errors.RepositoryError{
				Message: fmt.Sprintf("Erro de conexão com a base de dados.\n\n%s", err.Error()),
				Code:    ms_errors.NetworkError,
			}
		} else if mongo.IsTimeout(err) {
			return &ms_errors.RepositoryError{
				Message: "Tempo esgotado.",
				Code:    ms_errors.Timeout,
			}
		} else {
			return &ms_errors.RepositoryError{
				Message: fmt.Sprintf("Erro desconhecido: %s", err.Error()),
				Code:    ms_errors.Unkown,
			}
		}
	}

	return nil
}