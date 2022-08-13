package config

import (
	"context"
	"fmt"
	"server/src/utils"
	"time"

	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

// Estrutura que contém as informações necessárias para a conexão com o banco de dados MongoDB.
// As informações são: hostname, port, username e password.
type MongoConfig struct {
	hostname string
	port     string
	username string
	password string
}

var mongoConfig MongoConfig = MongoConfig{
	hostname: utils.GetEnv("MONGO_HOSTNAME"),
	port:     utils.GetEnv("MONGO_PORT"),
	username: utils.GetEnv("MONGO_USERNAME"),
	password: utils.GetEnv("MONGO_PASSWORD"),
}

// Conecta com o banco de dados MongoDB a partir de uma configuração do tipo MongoConfig.
// A configuração é gerada a partir das variáveis de ambiente MONGO_HOSTNAME, MONGO_PORT, MONGO_USERNAME e MONGO_PASSWORD.
// Retorna um client Mongo.
func ConnectToMongoDB() *mongo.Client {
	var uri string = fmt.Sprintf("mongodb://%s:%s", mongoConfig.hostname, mongoConfig.port)

	credential := options.Credential{
		AuthSource: "admin",
		Username:   mongoConfig.username,
		Password:   mongoConfig.password,
	}

	clientOptions := options.Client().ApplyURI(uri).SetAuth(credential)

	ctx, _ := context.WithTimeout(context.Background(), 10*time.Second)
	client, err := mongo.Connect(ctx, clientOptions)

	if err != nil {
		panic(err)
	} else {
		fmt.Println("Connected to MongoDB")
	}

	return client
}
