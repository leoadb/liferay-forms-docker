#!/bin/sh

if [ -z "$LIFERAY_HOME" ]; then
  echo '\nPlease set the environment variable: LIFERAY_HOME\n'
  exit 1
fi

ticket=$1

while [ -z "$ticket" ]; do
  read -p 'What is the ticket number: ' ticket
done

repository=$2

if [ -z "$repository" ]; then
  echo 'Where do you want to push the Docker image?'
  echo '1 - Local (default)'
  echo '2 - Docker Hub (external) '
  read repository
fi

if [ "$repository" = "2" ]; then
  docker build --no-cache -t liferay/com-liferay-forms-qa:$ticket -f ./Dockerfile $LIFERAY_HOME
  docker push liferay/com-liferay-forms-qa:$ticket
  docker rmi -f liferay/com-liferay-forms-qa:$ticket

  echo ""
  echo "Your JIRA Ticket is: $ticket"
  echo "Your Docker was created on: Docker Hub environment"

else
  echo 123456 | docker login -u forms --password-stdin 192.168.109.41:5000
  docker build --no-cache -t 192.168.109.41:5000/liferay/com-liferay-forms:$ticket -f ./Dockerfile $LIFERAY_HOME
  docker push 192.168.109.41:5000/liferay/com-liferay-forms:$ticket
  docker rmi -f 192.168.109.41:5000/liferay/com-liferay-forms:$ticket

  echo ""
  echo "Your JIRA Ticket is: $ticket"
  echo "Your Docker was created on: Local (192.168.109.41:5000) environment"

fi
