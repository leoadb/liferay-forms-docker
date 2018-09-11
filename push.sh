#!/bin/sh

if [ -z "$LIFERAY_HOME" ]; then
  echo '\nPlease set the environment variable: LIFERAY_HOME\n'
  exit 1
fi

ticket=''

while [ -z "$ticket" ]; do
  read -p 'What is the ticket number: ' ticket
done

echo 'Where do you want to push the Docker image?\n1 - Local (default)\n2 - Docker Hub (external)'

read repository

if [ -z "$repository" ]; then
  repository=1
fi

if [ $repository -eq 1 ]; then
  echo 123456 | docker login -u forms --password-stdin 192.168.109.41:5000
  docker build --no-cache -t 192.168.109.41:5000/liferay/com-liferay-forms:$ticket -f ./Dockerfile $LIFERAY_HOME
  docker push 192.168.109.41:5000/liferay/com-liferay-forms:$ticket
  docker rmi -f 192.168.109.41:5000/liferay/com-liferay-forms:$ticket
elif [ $repository -eq 2 ]; then
  docker build --no-cache -t liferay/com-liferay-forms-qa:$ticket -f ./Dockerfile $LIFERAY_HOME
  docker push liferay/com-liferay-forms-qa:$ticket
  docker rmi -f liferay/com-liferay-forms-qa:$ticket
fi
