package config

import (
	"context"
	"fmt"
	"server/src/utils"
	"time"

	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

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
