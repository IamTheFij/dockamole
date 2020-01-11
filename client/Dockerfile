ARG REPO=library
# Build mole for all arch
FROM golang:1.12-alpine AS builder

RUN apk add --no-cache git~=2.24 curl~=7.67 tar~=1.32

RUN mkdir /app

ENV MOLE_VERSION=0.4.0
RUN curl -L "https://github.com/davrodpin/mole/archive/v${MOLE_VERSION}.tar.gz" | tar zx -C /app
WORKDIR /app/mole-${MOLE_VERSION}

# Download dependencies so they can be cached
RUN go mod download

# Build static
ARG GOARCH=amd64
ENV CGO_ENABLED=0 GOOS=linux
RUN go build -a -ldflags "-X main.version=${MOLE_VERSION}-dockamole" -installsuffix nocgo -o /bin/mole github.com/davrodpin/mole/cmd/mole

# Build client image using target arch
FROM multiarch/qemu-user-static:4.1.0-1 as qemu-user-static
FROM ${REPO}/alpine:3.9

# Make multiarch capable
COPY --from=qemu-user-static /usr/bin/qemu-* /usr/bin/
# Copy mole from builder
COPY --from=builder /bin/mole /usr/bin/mole

RUN apk --no-cache add bash=4.4.19-r1 openssh-client=7.9_p1-r6

RUN mkdir /mole
RUN adduser -S -h /mole mole

USER mole

RUN mkdir -p /mole/.ssh
RUN touch /mole/.ssh/config
# Make a volume to persist keys
VOLUME /mole/.ssh

# Generate known hosts on first connect
ENV GEN_KNOWN_HOSTS=1

COPY ./start.sh ./

CMD ./start.sh
