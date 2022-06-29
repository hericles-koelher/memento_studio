package controllers_tests

import (
	"testing"
	// "fmt"
	// "bytes"
	"net/http"
	// "encoding/json"

	// "server/src/models"
	
	"github.com/stretchr/testify/assert"
	
	// "io"
)

func TestReadAllDeckReference(t *testing.T) {
	request, err := http.NewRequest(http.MethodGet, "/decksReference", nil)
	if err != nil {
		t.FailNow()
	}
	
	router.ServeHTTP(responseRecorder, request)

	assert.Equal(t, http.StatusOK, responseRecorder.Code)
}

