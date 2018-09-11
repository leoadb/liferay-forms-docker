#!/bin/sh

read -p 'What is the ticket number: ' ticket

echo 'Where do you want to pull the Docker image?\n1 - Local (default)\n2 - Docker Hub (external)'

read repository

if [ -z "$repository" ]; then
  repository=1
fi

read -p 'What is the port number you want to run the server (8080): ' port

if [ -z "$port" ]; then
  port=8080
fi

container=$(docker ps -a | grep "$ticket" | wc -l)

if [ $container -eq 1 ]; then
  docker kill $ticket
  docker rm -f $ticket
fi

if [ $repository -eq 1 ]; then
  docker pull 192.168.109.41:5000/liferay/com-liferay-forms:$ticket
  docker run -p $port:8080 --name $ticket 192.168.109.41:5000/liferay/com-liferay-forms:$ticket
elif [ $repository -eq 2 ]; then
  docker pull liferay/com-liferay-forms-qa:$ticket
  docker run -p $port:8080 --name $ticket liferay/com-liferay-forms-qa:$ticket
fi
