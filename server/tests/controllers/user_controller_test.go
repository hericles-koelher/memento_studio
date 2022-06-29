package controllers_tests

import (
	"fmt"
	"io"
	"testing"
	"net/http"
	"encoding/json"
	
	"server/src/models"
	
	"github.com/stretchr/testify/assert"
)

func TestCreateUser(t *testing.T) {
	responseRecorder.Body.Reset()

	request, err := http.NewRequest(http.MethodPost, "/api/users", nil)
	if err != nil {
		t.FailNow()
	}
	
	router.ServeHTTP(responseRecorder, request)

	assert.Equal(t, http.StatusOK, responseRecorder.Code)
}

func TestDeleteUser(t *testing.T) {
	responseRecorder.Body.Reset()

	request, err := http.NewRequest(http.MethodDelete, "/api/users", nil)
	if err != nil {
		t.FailNow()
	}
	
	router.ServeHTTP(responseRecorder, request)

	assert.Equal(t, http.StatusOK, responseRecorder.Code)
}

func TestGetUser(t *testing.T) {
	responseRecorder.Body.Reset()

	request, err := http.NewRequest(http.MethodGet, "/api/users", nil)
	if err != nil {
		t.FailNow()
	}
	
	router.ServeHTTP(responseRecorder, request)

	var responseUser *models.User
	response, _ := io.ReadAll(responseRecorder.Body)
	err = json.Unmarshal(response, &responseUser)

	if err != nil {
		fmt.Println("Could not parse response: response body is not a user")
		t.FailNow()
	}

	assert.Equal(t, http.StatusOK, responseRecorder.Code)
	assert.Equal(t, userId, responseUser.UUID)
}