package utils

import (
	"os"
	"path/filepath"
	"strings"
)

const (
	imagesDirKey = "IMAGES_FILE_PATH"
	baseRoute    = "http://localhost:8080/"
)

func UploadFile(file []byte, folderName, filename string) (string, error) {
	var imageFilepath = GetImageRoute(folderName, filename)
	var imagesDir = GetImagesFilePath()

	os.Mkdir(imagesDir+"/"+folderName, 0755)

	err := os.WriteFile(imagesDir+folderName+"/"+filename, file, 0755)
	if err != nil {
		return "", err
	}

	return imageFilepath, nil
}

func RemoveFile(filename, folderName string) error {
	if !strings.Contains(filename, folderName) {
		return nil
	}

	var imagesDir = GetImagesFilePath()

	absPath, _ := filepath.Abs(imagesDir + folderName + "/" + filename)

	err := os.Remove(absPath)

	return err
}

func RemoveFolder(folder string) error {
	var imagesDir = GetImagesFilePath()

	absPath, _ := filepath.Abs(imagesDir + folder)

	err := os.RemoveAll(absPath)

	return err
}

func GetImagesFilePath() string {
	var imagesDir = "../../public/" // for tests

	if value, ok := os.LookupEnv(imagesDirKey); ok { // in container
		imagesDir = value
	}

	return imagesDir
}

func GetImageRoute(folderName, filename string) string {
	var route = baseRoute

	if value, ok := os.LookupEnv("BASE_ROUTE"); ok { // in container
		route = value
	}

	return route + "image/" + folderName + "/" + filename
}
