COMPOSE= docker-compose -f srcs/docker-compose.yml

all: build up

build:
	$(COMPOSE) build

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

restart: down up

fclean:
	docker-compose -f srcs/docker-compose.yml down --volumes --rmi all

	docker system prune -af

	sudo rm -rf ${HOME}/InceptionData/mariadb/*	

	sudo rm -rf ${HOME}/InceptionData/wordpress/*	

logs:
	$(COMPOSE) logs -f

.PHONY: all up down build restart logs fclean
