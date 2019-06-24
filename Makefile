.PHONY: default
default: remote client

.PHONY: remote
remote:
	docker-compose -f ./docker-compose-remote.yml up -d

.PHONY: client
client:
	docker-compose -f ./docker-compose-client.yml build
	docker-compose -f ./docker-compose-client.yml up -d

.PHONY: logs
logs:
	docker-compose -f ./docker-compose-client.yml logs -f
