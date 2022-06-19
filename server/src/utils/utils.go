package utils

import (
	"os"
	"io"
	"io/ioutil"
	"encoding/json"
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

	err := json.Unmarshal(bodyBytes, result)

	return err
}