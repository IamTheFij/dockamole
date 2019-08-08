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
