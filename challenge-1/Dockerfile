FROM golang:1.22

WORKDIR /go/src
COPY . .
RUN go build -o webserver -ldflags "-linkmode external -extldflags -static" -a main.go

FROM scratch
COPY --from=0 /go/src/webserver /webserver
ENTRYPOINT ["/webserver"]
