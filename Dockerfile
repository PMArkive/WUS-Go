FROM golang:1.10 as builder
RUN mkdir -p /go/src/github.com/RiiConnect24/WUS-Go
WORKDIR /go/src/github.com/RiiConnect24/WUS-Go
# Copy the entire WUS-Go source into builder's source.
COPY . .
RUN go get -d
# Build to name "app".
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o app .

FROM jwilder/dockerize
WORKDIR /
COPY --from=builder /go/src/github.com/RiiConnect24/WUS-Go/app .
# Wait until there's an actual MySQL connection we can use to start.
CMD ["dockerize", "-wait", "tcp://database:3306", "-timeout", "60s", "/app"]