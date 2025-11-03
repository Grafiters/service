FROM golang:1.24-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod tidy
COPY . .
RUN go build -o main .

FROM alpine:latest
WORKDIR /app
RUN apk add --no-cache mysql-client tzdata
COPY --from=builder /app/main .
CMD ["./main","serve-http" ]
