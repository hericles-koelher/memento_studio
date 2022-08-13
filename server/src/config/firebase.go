package config

import (
	"context"
	"path/filepath"

	firebase "firebase.google.com/go"
	"firebase.google.com/go/auth"
	"google.golang.org/api/option"
)

// Configura uma aplicação Firebase. O Firebase é utilizado para autenticação dos usuários.
// É necessário que haja a chave de acesso do firebase no caminho './src/config/serviceAccountKey.json'.
// Retorna um cliente Firebase.
func SetupFirebase() *auth.Client {
	serviceAccountKeyFilePath, err := filepath.Abs("./src/config/serviceAccountKey.json")

	if err != nil {
		panic("Unable to load serviceAccountKeys.json file")
	}

	opt := option.WithCredentialsFile(serviceAccountKeyFilePath)

	//Firebase admin SDK initialization
	app, err := firebase.NewApp(context.Background(), nil, opt)

	if err != nil {
		panic("Firebase load error")
	}

	//Firebase Auth
	client, err := app.Auth(context.Background())

	if err != nil {
		panic("Firebase load error")
	}

	return client
}
