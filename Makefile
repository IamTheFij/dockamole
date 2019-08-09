DOCKER_TAG := dockamole
MOLE_VERSION := 0.4.0

.PHONY: default
default: server client

.PHONY: all
all: server client

.PHONY: stop
stop:
	docker-compose -f ./docker-compose-server.yml stop
	docker-compose -f ./docker-compose-client.yml stop

.PHONY: restart
restart:
	docker-compose -f ./docker-compose-server.yml restart
	docker-compose -f ./docker-compose-client.yml restart

.PHONY: down
down:
	docker-compose -f ./docker-compose-client.yml down -v
	docker-compose -f ./docker-compose-server.yml down -v

.PHONY: server
server: keys
	docker-compose -f ./docker-compose-server.yml build
	docker-compose -f ./docker-compose-server.yml up -d

.PHONY: client
client:
	docker-compose -f ./docker-compose-client.yml build
	docker-compose -f ./docker-compose-client.yml up -d

.PHONY: server-logs
server-logs:
	docker-compose -f ./docker-compose-server.yml logs -f

.PHONY: client-logs
client-logs:
	docker-compose -f ./docker-compose-client.yml logs -f

keys:
	mkdir -p keys/etc/ssh
	ssh-keygen -A -f keys/

keys/etc/ssh/ssh_host_dsa_key: keys
keys/etc/ssh/ssh_host_ecdsa_key: keys
keys/etc/ssh/ssh_host_ed25519_key: keys
keys/etc/ssh/ssh_host_rsa_key: keys
keys/known_hosts: keys

# Build images

.PHONY: build
build: build-client build-server

.PHONY: build-client
build-client:
	docker build client -t $(DOCKER_TAG)-client

.PHONY: build-server
build-server:
	docker build server -t $(DOCKER_TAG)-server

.PHONY: build-arm32v6
build-arm32v6: build-client-arm32v6 build-server-arm32v6

.PHONY: build-client-arm32v6
build-client-arm32v6:
	docker build client --build-arg REPO=arm32v6 --build-arg GOARCH=arm -t $(DOCKER_TAG)-client-arm32v6

.PHONY: build-server-arm32v6
build-server-arm32v6:
	docker build server --build-arg REPO=arm32v6 -t $(DOCKER_TAG)-server-arm32v6

.PHONY: build-arm32v7
build-arm32v7: build-client-arm32v7 build-server-arm32v7

.PHONY: build-client-arm32v7
build-client-arm32v7:
	docker build client --build-arg REPO=arm32v7 --build-arg GOARCH=arm -t $(DOCKER_TAG)-client-arm32v7

.PHONY: build-server-arm32v7
build-server-arm32v7:
	docker build server --build-arg REPO=arm32v7 -t $(DOCKER_TAG)-server-arm32v7

.PHONY: build-arm64v8
build-arm64v8: build-client-arm64v8 build-server-arm64v8

.PHONY: build-client-arm64v8
build-client-arm64v8:
	docker build client --build-arg REPO=arm64v8 --build-arg GOARCH=arm64 -t $(DOCKER_TAG)-client-arm64v8

.PHONY: build-server-arm64v8
build-server-arm64v8:
	docker build server --build-arg REPO=arm64v8 -t $(DOCKER_TAG)-server-arm64v8

.PHONY: build-all
build-all: build build-arm32v6 build-arm64v8
