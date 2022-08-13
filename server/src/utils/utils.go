package utils

import (
	"encoding/json"
	"io"
	"io/ioutil"
	"net/http"
	"os"

	"server/src/errors"
)

type compareFunc func(interface{}, interface{}) bool

type arrComparable interface {
	string | int | float64
}

// Pega uma variável de ambiente. Gera um panic, caso a variável não exista.
func GetEnv(key string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}

	panic("Environment variable: " + key + " not found")
}

// Verifica se um elemento está contido em uma lista. É necessário passar a função de comparação.
// A função de comparação tem a assinatura 'func(interface{}, interface{}) bool'.
func Contains[T arrComparable](arr []T, value interface{}, compare compareFunc) bool {
	for _, elem := range arr {
		if compare(elem, value) {
			return true
		}
	}

	return false
}

// Lê o body de uma requsição e faz o parser para um map[string]interface{}. Retorna um error,
// caso algo dê errado.
func GetRequestBody(bodyBuffer io.ReadCloser, result *map[string]interface{}) error {
	bodyBytes, _ := ioutil.ReadAll(bodyBuffer)
	defer bodyBuffer.Close()

	if len(bodyBytes) == 0 {
		return nil
	}

	err := json.Unmarshal(bodyBytes, result)

	return err
}

// Remove a primeira ocorrência de uma string em uma lista de string. Retorna uma lista
// sem a string passada por parâmetro.
func Remove(arr []string, value string) []string {
	for i, v := range arr {
		if v == value {
			return append(arr[:i], arr[i+1:]...)
		}
	}

	return arr
}

// Retorna um status http, dado um erro de repositório 'RepositoryError'.
func HandleRepositoryError(err *errors.RepositoryError) int {
	switch err.Code {
	case errors.DuplicateKey:
		return http.StatusForbidden
	case errors.Timeout:
		return http.StatusRequestTimeout
	default:
		return http.StatusInternalServerError
	}
}
