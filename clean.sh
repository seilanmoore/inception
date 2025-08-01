#! /bin/bash

docker-compose -f srcs/docker-compose.yml down --volumes --rmi all

sudo rm -rf $HOME/InceptionData/mariadb/*	

sudo rm -rf $HOME/InceptionData/wordpress/*	
