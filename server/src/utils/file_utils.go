package utils

import (
	"os"
	"path/filepath"
	"strings"
)

const (
	imagesDirKey = "IMAGES_FILE_PATH"
)

// Salva uma imagem em uma dada pasta com um dado nome. Retorna o caminho da imagem e um erro, caso algo dê errado.
func UploadFile(file []byte, folderName, filename string) (string, error) {
	var imageFilepath = getImageRoute(folderName, filename)
	var imagesDir = getImagesFilePath()

	os.Mkdir(imagesDir+"/"+folderName, 0755)

	err := os.WriteFile(imagesDir+folderName+"/"+filename, file, 0755)
	if err != nil {
		return "", err
	}

	return imageFilepath, nil
}

// Remove um arquivo dado o nome dele e a pasta. Retorna um erro, caso algo dê errado.
func RemoveFile(filename, folderName string) error {
	if !strings.Contains(filename, folderName) {
		return nil
	}

	var imagesDir = getImagesFilePath()

	absPath, _ := filepath.Abs(imagesDir + folderName + "/" + filename)

	err := os.Remove(absPath)

	return err
}

// Apaga uma pasta com um dado nome. Retorna um erro, caso algo dê errado.
func RemoveFolder(folder string) error {
	var imagesDir = getImagesFilePath()

	absPath, _ := filepath.Abs(imagesDir + folder)

	err := os.RemoveAll(absPath)

	return err
}

func getImagesFilePath() string {
	var imagesDir = "../../public/" // for tests

	if value, ok := os.LookupEnv(imagesDirKey); ok { // in container
		imagesDir = value
	}

	return imagesDir
}

func getImageRoute(folderName, filename string) string {
	return "image/" + folderName + "/" + filename
}
