package utils

import (
	"os"
	"path/filepath"
)

const (
	ImagesRoute 	= "http://localhost:8080/image"
	ImagesDir 		= "../../public/"
)

func UploadFile(file []byte, filename string) (string, error) {
	var imageFilepath = ImagesRoute + "/" + filename
	absPath, _ := filepath.Abs(ImagesDir + filename)

	err := os.WriteFile(absPath, file, 0644)
	if err != nil {
		return "", err
	}

	return imageFilepath, nil
}