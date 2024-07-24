FROM golang:1.21-bullseye AS build-img

WORKDIR /go/src/app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build

FROM gcr.io/distroless/base-debian11:latest
COPY --from=build-img /usr/bin/ldd /usr/bin/ldd
COPY --from=build-img /go/src/app/bpfib /usr/bin/bpfib
ENTRYPOINT ["/usr/bin/bpfib"]
