FROM golang:1.19.0 as builder
WORKDIR /go/src/
COPY ./ ./
RUN go get -d -v .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o app .

FROM alpine:latest  
ENV DB_USER=root
ENV DB_PASSWORD=example
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /go/src/app ./
CMD ["./app"]  
