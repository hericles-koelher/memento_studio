FROM golang:1.18

WORKDIR /app
COPY . .

RUN go get -d -v ./src/
RUN go build -o server -v ./src/

CMD ["./server"]
