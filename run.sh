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
  docker run -p $PORT:8080 --name $TICKET liferay/com-liferay-forms:$TICKET
fi
