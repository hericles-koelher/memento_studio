package errors

import "fmt"

// Código de erro do repositório
type ErrorCode int16

// O código de erro 'ErrorCode' do repositório pode ser um dos mostrados abaixo
const (
	DuplicateKey ErrorCode = iota
	NetworkError
	Timeout
	Unkown
)

// Tipo de erro retornado por um repositório. Contém uma mensagem e o código de erro.
type RepositoryError struct {
	Message string
	Code    ErrorCode
}

// Printa o código e a mensagem do erro de repositório
func (err RepositoryError) Error() string {
	return fmt.Sprintf("Message: %s\nCode: %d", err.Message, err.Code)
}
