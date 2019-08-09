ARG REPO=library
# Build mole for all arch
FROM golang:1.12-alpine AS builder

ENV MOLE_VERSION=0.4.0

RUN apk add --no-cache git curl tar

RUN mkdir /app
RUN curl -L https://github.com/davrodpin/mole/archive/v${MOLE_VERSION}.tar.gz | tar zx -C /app
WORKDIR /app/mole-${MOLE_VERSION}

# Download dependencies so they can be cached
RUN go mod download

# Build static
ARG GOARCH=amd64
ENV CGO_ENABLED=0 GOOS=linux
RUN go build -a -ldflags '-X main.version=${MOLE_VERSION}-dockamole' -installsuffix nocgo -o /bin/mole github.com/davrodpin/mole/cmd/mole

# Build client image using target arch
FROM ${REPO}/alpine

# Make multiarch capable
COPY --from=multiarch/qemu-user-static /usr/bin/qemu-* /usr/bin/
# Copy mole from builder
COPY --from=builder /bin/mole /usr/bin/mole

RUN apk --no-cache add bash openssh-client

RUN mkdir /mole
RUN adduser -S -h /mole mole

USER mole

RUN mkdir -p /mole/.ssh
RUN touch /mole/.ssh/config
# Make a volume to persist keys
VOLUME /mole/.ssh

ENV GEN_KNOWN_HOSTS=1

COPY ./start.sh ./

CMD ./start.sh
