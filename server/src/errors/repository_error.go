package errors

import "fmt"

type ErrorCode int16

const (
	DuplicateKey ErrorCode = iota
	NetworkError
	Timeout
	Unkown
)

type RepositoryError struct {
	Message string
	Code    ErrorCode
}

func (err RepositoryError) Error() string {
	return fmt.Sprintf("Message: %s\nCode: %d", err.Message, err.Code)
}