#!/bin/sh

TICKET=$1

if [ -z "$TICKET" ]; then
  echo '\nPlease inform the ticket number.\n'
  exit 1
elif [ -z "$LIFERAY_HOME" ]; then
  echo '\n Please set the environment variable: LIFERAY_HOME\n'
  exit 1
else
  docker build -t liferay/com-liferay-forms:$TICKET $LIFERAY_HOME
  docker push liferay/com-liferay-forms:$TICKET
fi
