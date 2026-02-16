FROM --platform=$BUILDPLATFORM golang:1.24-alpine3.21 AS builder

ARG TARGETOS
ARG TARGETARCH

WORKDIR /app
COPY . .

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o /app/fsb -ldflags="-w -s" ./cmd/fsb

FROM alpine:3.21

# Choreo-র সিকিউরিটি পলিসি অনুযায়ী নন-রুট ইউজার তৈরি
RUN adduser -D -u 10014 choreo-user
USER 10014

WORKDIR /app
COPY --from=builder /app/fsb /app/fsb

EXPOSE 8080
ENTRYPOINT ["/app/fsb", "run"]
