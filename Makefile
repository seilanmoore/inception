COMPOSE= docker-compose -f srcs/docker-compose.yml

build:
	$(COMPOSE) build

up:
	$(COMPOSE) up -d

down:
	./clean.sh

restart: down build up

logs:
	$(COMPOSE) logs -f

.PHONY: up down build restart logs
