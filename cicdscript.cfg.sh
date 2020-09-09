#!/bin/bash

source cicd.cfg


if $jenkins_enable
then
	echo "*******************************************"
	echo "Build Jenkins image"
	echo "*******************************************"
	docker build -t $jenkins_image_name  --build-arg groupname=$(id -gn) --build-arg groupid=$(id -g) $jenkins_dockerfile_path
fi

if $jenkins_auto_start
then
	echo "*******************************************"
	echo "Creating working space for Jenkins on the host machine"
	echo "*******************************************"
	mkdir $jenkins_working_folder
	
	echo "*******************************************"
	echo "Start Jenkins image"
	echo "*******************************************"
	base_start_string="docker run -d -v ${jenkins_working_folder}:/var/jenkins_home"
	if $jenkins_host_socket_accessible
	then
		base_start_string="${base_start_string} -v /var/run/docker.sock:/var/run/docker.sock"
	fi
	base_start_string="${base_start_string} -p ${jenkins__host_port}:8080 -p 50000:50000 $jenkins_image_name"
	eval $base_start_string
fi

if $node_enable
then
	echo "*******************************************"
	echo "Build Node image"
	echo "*******************************************"
	docker build -t $node_image_name $node_dockerfile_path
fi

if $maven_enable
then
	echo "*******************************************"
	echo "Build Maven image"
	echo "*******************************************"
	docker build -t $maven_image_name $maven_dockerfile_path
fi

if $jdk_enable
then
	echo "*******************************************"
	echo "Build Maven image"
	echo "*******************************************"
	docker build -t $jdk_image_name --build-arg jarname=$jar_name $jdk_dockerfile_path
fi

echo "*******************************************"
echo "Set up completed"
echo "*******************************************"
docker --version
docker images
docker ps
