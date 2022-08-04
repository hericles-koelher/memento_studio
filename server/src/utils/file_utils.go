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

func UploadFile(file []byte, folderName, filename string) (string, error) {
	var imageFilepath = ImagesRoute + "/" + folderName + "/" + filename
	var imagesDir = GetImagesFilePath()

	os.Mkdir(imagesDir + "/" + folderName, 0755)

	err := os.WriteFile(imagesDir + folderName + "/" + filename, file, 0755)
	if err != nil {
		return "", err
	}

	return imageFilepath, nil
}

func RemoveFile(onlinePath, folder string) error {
	filename := strings.Replace(onlinePath, ImagesRoute + "/", "", -1)
	if !strings.Contains(filename, folder) {
		return nil
	}

	var imagesDir = GetImagesFilePath()

	absPath, _ := filepath.Abs(imagesDir + filename)

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
	var imagesDir	  = "../../public/" // for tests

	if value, ok := os.LookupEnv(imagesDirKey); ok { // in container
		imagesDir = value
	}

	return imagesDir
}