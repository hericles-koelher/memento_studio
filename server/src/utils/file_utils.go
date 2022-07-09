package utils

import (
	"os"
	"strings"
	"path/filepath"
)

const (
	ImagesRoute 	= "http://localhost:8080/image"
	imagesDirKey	= "IMAGES_FILE_PATH"
)

func UploadFile(file []byte, filename string) (string, error) {
	var imageFilepath = ImagesRoute + "/" + filename
	var imagesDir = getImagesFilePath()

	err := os.WriteFile(imagesDir + filename, file, 0644)
	if err != nil {
		return "", err
	}

	return imageFilepath, nil
}

func RemoveFile(onlinePath string) error {
	filename := strings.Replace(onlinePath, ImagesRoute + "/", "", -1)
	var imagesDir = getImagesFilePath()

	absPath, _ := filepath.Abs(imagesDir + filename)

	err := os.Remove(absPath)

	return err
}

func getImagesFilePath() string {
	var imagesDir	  = "../../public/" // for tests

	if value, ok := os.LookupEnv(imagesDirKey); ok { // in container
		imagesDir = value
	}

	return imagesDir
}