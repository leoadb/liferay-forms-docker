#!/bin/sh

TICKET=$1

PORT=$2

echo $PORT

if [ -z "$TICKET" ]; then
  echo '\nPlease inform the ticket number.\n'
  exit 1
else
  if [ -z "$PORT" ]; then
    PORT=8080
  fi
  docker kill $TICKET
  docker rm -f $TICKET
  docker pull 192.168.109.41:5000/liferay/com-liferay-forms:$TICKET
  docker run -p $PORT:8080 --name $TICKET 192.168.109.41:5000/liferay/com-liferay-forms:$TICKET
fi
