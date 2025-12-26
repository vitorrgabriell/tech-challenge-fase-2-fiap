FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY . .
RUN go mod download && go mod tidy
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o evaluation-service .

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/evaluation-service .
EXPOSE 8004
CMD ["./evaluation-service"]