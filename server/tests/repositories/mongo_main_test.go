package repositories_tests

import (
	"context"
	"fmt"
	"log"
	"strings"
	"testing"
	"time"

	"github.com/strikesecurity/strikememongo"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
	"go.mongodb.org/mongo-driver/mongo/readpref"

	"server/src/repositories"
	"server/src/repositories/interfaces"
)

// Reference:
// https://medium.com/strike-sh/golang-using-an-inmemory-mongodb-for-unit-testing-with-transactions-866b5f174cbe

// ----------------------------------------
// 	  AUXILIARY VARIABLES AND CONSTANTS
// ----------------------------------------
const (
	// collection constants
	usersCollectionName          = "users"
	decksCollectionName          = "decks"
	decksReferenceCollectionName = "decksReference"
)

var (

	// collections variables
	usersCollection          *mongo.Collection
	decksCollection          *mongo.Collection
	decksReferenceCollection *mongo.Collection

	databaseName = ""
	mongoURI     = ""
	database     *mongo.Database

	userRepository          interfaces.UserRepository
	deckRepository          interfaces.DeckRepository
	deckReferenceRepository interfaces.DeckReferenceRepository
)

// ----------------------------
// 		TEST MAIN FUNCTION
// ----------------------------

func TestMain(m *testing.M) {
	mongoServer, err := strikememongo.StartWithOptions(&strikememongo.Options{MongoVersion: "4.2.0", ShouldUseReplica: false})
	if err != nil {
		log.Fatal(err)
	}
	mongoURI = mongoServer.URIWithRandomDB()
	splitedDatabaseName := strings.Split(mongoURI, "/")
	databaseName = splitedDatabaseName[len(splitedDatabaseName)-1]

	defer mongoServer.Stop()

	setup()
	m.Run() // Vai rodar todos os testes do pacote
}

// ----------------------------
// 		SET UP FUNCTION
// ----------------------------
func setup() {
	startApplication()
	createCollections()
	createRepositories()
	cleanup()
}

// createCollections creates the necessary collections to be used during tests
func createCollections() {
	err := database.CreateCollection(context.Background(), usersCollectionName)
	if err != nil {
		fmt.Printf("error creating collection: %s", err.Error())
	}

	err = database.CreateCollection(context.Background(), decksCollectionName)
	if err != nil {
		fmt.Printf("error creating collection: %s", err.Error())
	}

	err = database.CreateCollection(context.Background(), decksReferenceCollectionName)
	if err != nil {
		fmt.Printf("error creating collection: %s", err.Error())
	}

	usersCollection = database.Collection(usersCollectionName)
	decksCollection = database.Collection(decksCollectionName)
	decksReferenceCollection = database.Collection(decksReferenceCollectionName)
}

// createRepositories creates the necessary repositories to be used during tests
func createRepositories() {
	userRepository = repositories.NewMongoUserRepository(usersCollection)
	deckRepository = repositories.NewMongoDeckRepository(decksCollection)
	deckReferenceRepository = repositories.NewMongoDeckReferenceRepository(decksReferenceCollection)
}

// startApplication initializes the engine and the necessary components for the (test) service to work
func startApplication() {
	// Initialize Database (memongodb)
	dbClient, ctx, err := initDB()
	if err != nil {
		log.Fatal("error connecting to database", err)
	}

	err = dbClient.Ping(ctx, readpref.Primary())
	if err != nil {
		log.Fatal("error connecting to database", err)
	}

	database = dbClient.Database(databaseName)
}

func initDB() (client *mongo.Client, ctx context.Context, err error) {
	uri := fmt.Sprintf("%s%s", mongoURI, "?retryWrites=false")
	client, err = mongo.NewClient(options.Client().ApplyURI(uri))
	if err != nil {
		return
	}

	ctx, _ = context.WithTimeout(context.Background(), 10*time.Second)
	err = client.Connect(ctx)
	if err != nil {
		return
	}

	return
}

// ----------------------------
// 		TEAR DOWN FUNCTION
// ----------------------------
func cleanup() {
	usersCollection.DeleteMany(context.Background(), bson.M{})
	decksCollection.DeleteMany(context.Background(), bson.M{})
	decksReferenceCollection.DeleteMany(context.Background(), bson.M{})
}
