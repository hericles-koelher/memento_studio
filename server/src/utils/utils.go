package utils

import (
	"os"
	"io"
	"net/http"
	"io/ioutil"
	"encoding/json"

	"server/src/errors"
)
type compareFunc func(interface{}, interface{}) bool

type arrComparable interface {
	string | int | float64
}

func GetEnv(key string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}

	panic("Environment variable: " + key + " not found")
}

func Contains[T arrComparable](arr []T, value interface{}, compare compareFunc) bool {
	for _, elem := range arr {
		if compare(elem, value) {
			return true
		}
	}

	return false
}

func GetRequestBody(bodyBuffer io.ReadCloser, result *map[string]interface{}) error {
	bodyBytes, _ := ioutil.ReadAll(bodyBuffer)
	defer bodyBuffer.Close()

	if len(bodyBytes) == 0 {
		result = nil
		return nil
	}

	err := json.Unmarshal(bodyBytes, result)

	return err
}

func Remove(arr []string, value string) []string {
	for i, v := range arr {
		if v == value {
			return append(arr[:i], arr[i+1:]...)
		}
	}

	return arr
}

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