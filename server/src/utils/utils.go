package utils

import (
	"os"
	"io"
	"io/ioutil"
	"encoding/json"
)
type compareFunc func(interface{}, interface{}) bool

func GetEnv(key string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}

	panic("Environment variable: " + key + " not found")
}

func Contains(arr interface{}, value interface{}, compare compareFunc) bool {
	array := arr.([]interface{})
	
	for _, elem := range array {
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