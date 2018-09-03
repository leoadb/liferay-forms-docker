#!/bin/sh

TICKET=$1

if [ -z "$TICKET" ]; then
  echo '\nPlease inform the ticket number.\n'
  exit 1
elif [ -z "$LIFERAY_HOME" ]; then
  echo '\n Please set the environment variable: LIFERAY_HOME\n'
  exit 1
else
  echo 123456 | docker login -u forms --password-stdin 192.168.109.41:5000
  docker build -t 192.168.109.41:5000/liferay/com-liferay-forms:$TICKET -f ./Dockerfile $LIFERAY_HOME
  docker push 192.168.109.41:5000/liferay/com-liferay-forms:$TICKET
fi
