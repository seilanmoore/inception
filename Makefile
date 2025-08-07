COMPOSE= docker compose -f srcs/docker-compose.yml

all:
	$(COMPOSE) up -d --build

build:
	$(COMPOSE) build

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

restart: down build up

logs:
	$(COMPOSE) logs -f

clean:
	$(COMPOSE) down

fclean: clean
	sudo rm -rf $(HOME)/data/mariadb/*
	sudo rm -rf $(HOME)/data/wordpress/*

re: fclean all

.PHONY: all clean fclean re up down build logs

