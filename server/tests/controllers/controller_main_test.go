package controllers_tests

import (
	"testing"

	"github.com/gin-gonic/gin"
	"net/http/httptest"

	"server/tests/repositories/mocks"
	"server/src/routes"
	"server/src/repositories/interfaces"
)

const (
	userId	string 		= "testuserid"
	deckId	string		= "testdeckid"
)

var (
	ginContext 			*gin.Context
	router				*gin.Engine
	responseRecorder	*httptest.ResponseRecorder

	userRepository				interfaces.UserRepository
	deckRepository				interfaces.DeckRepository
	deckReferenceRepository		interfaces.DeckReferenceRepository
)

// ----------------------------
// 		TEST MAIN FUNCTION
// ----------------------------

func TestMain(m *testing.M) {
	setup()
	m.Run() // Vai rodar todos os testes do pacote
}

func setup() {
	setupRouter()
	setupUser()
	setupRepositories()
	setupRoutes()
}

func setupRouter() {
	responseRecorder = httptest.NewRecorder()
	ginContext, router = gin.CreateTestContext(responseRecorder)
}

func setupRoutes() {
	serverApi := router.Group("/api")
	routes.DeckRoutesTest(serverApi)
	routes.DeckReferenceRoutes(serverApi)
	routes.UserRoutesTest(serverApi)
}

func setupUser() {
	router.Use(func (context *gin.Context) {
		context.Set("UUID", userId)
	})
}

func setupRepositories() {
	userRepository = repositories_mock.NewUserRepositoryMock(userId, []string{deckId})
	deckRepository = repositories_mock.NewDeckRepositoryMock()
	deckReferenceRepository = repositories_mock.NewDeckReferenceRepositoryMock()

	router.Use(func (context *gin.Context) {
		context.Set("userRepository", userRepository)
		context.Set("deckRepository", deckRepository)
		context.Set("deckReferenceRepository", deckReferenceRepository)
	})
}