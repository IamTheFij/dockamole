.PHONY: default
default: remote client

.PHONY: all
all: remote client

.PHONY: stop
stop:
	docker-compose -f ./docker-compose-remote.yml stop
	docker-compose -f ./docker-compose-client.yml stop

.PHONY: restart
restart:
	docker-compose -f ./docker-compose-remote.yml restart
	docker-compose -f ./docker-compose-client.yml restart

.PHONY: down
down:
	docker-compose -f ./docker-compose-remote.yml down
	docker-compose -f ./docker-compose-client.yml down

.PHONY: remote
remote:
	docker-compose -f ./docker-compose-remote.yml build
	docker-compose -f ./docker-compose-remote.yml up -d

.PHONY: client
client:
	docker-compose -f ./docker-compose-client.yml build
	docker-compose -f ./docker-compose-client.yml up -d

.PHONY: remote-logs
remote-logs:
	docker-compose -f ./docker-compose-remote.yml logs -f

.PHONY: client-logs
client-logs:
	docker-compose -f ./docker-compose-client.yml logs -f
