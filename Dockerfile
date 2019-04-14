FROM golang:alpine AS build-env

COPY src /opt/src

WORKDIR /opt/src

RUN GOOS=linux GOARCH=amd64 go build -o server

FROM alpine:latest

RUN apk add --no-cache tini

COPY --from=build-env /opt/src/server /usr/local/bin/server

WORKDIR /usr/local/bin
EXPOSE 8080
ENV TIMEOUT 60

CMD ["/sbin/tini", "--", "sh", "-c", "timeout -t $TIMEOUT -s KILL ./server"]
