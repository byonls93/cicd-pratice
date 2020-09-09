#!/bin/bash

source cicd.cfg

if $docker_enable
then
	echo "*******************************************"
	echo "Get docker script"
	echo "*******************************************"
	curl -fsSL https://get.docker.com -o get-docker.sh
	ls -lrt get-docker.sh

	echo "*******************************************"
	echo "Install docker and docker cli"
	echo "*******************************************"
	sh get-docker.sh
	
	echo "*******************************************"
	echo "Add $docker_user to docker group"
	echo "*******************************************"
	sudo usermod -aG docker $docker_user
	
	echo "*******************************************"
	echo "Enter password for $docker_user start new session for group updating"
	echo "*******************************************"
	su - $USER
fi