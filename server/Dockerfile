FROM golang:1.18

WORKDIR /app
COPY . .

RUN go get -d -v
RUN go build -v

CMD ["./server"]
