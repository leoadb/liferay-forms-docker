#!/bin/sh

echo 'What do you wanna do?'
echo '1 - See the status of all my dockers containers'
echo '2 - See the status of all my dockers images'
echo '3 - See the status of a specific docker containers'
echo '4 - Start a specific docker containers'
echo '5 - Stop a specific docker containers'
echo '6 - See the log of a specific docker containers'
echo '7 - Kill a specific docker containers and your image'
read option

if [ "$option" = "1" ]; then
	docker ps -a
elif [ "$option" = "2" ]; then
	docker images
elif [ "$option" = "3" ]; then
	read -p 'What is the ticket number: ' ticket
	docker ps -f name=$ticket
elif [ "$option" = "4" ]; then
	read -p 'What is the ticket number: ' ticket
	docker start $ticket
elif [ "$option" = "5" ]; then
	read -p 'What is the ticket number: ' ticket
	docker stop $ticket
elif [ "$option" = "6" ]; then
	read -p 'What is the ticket number: ' ticket
	docker logs -f $ticket
elif [ "$option" = "7" ]; then
	echo 'Do you really wanna do this? (yes / no)'
	read abortOption

	if [ "$abortOption" = "no" ]; then
	  echo 'Operation aborted'
	  exit 1
	fi

	read -p 'What is the ticket number: ' ticket
	docker stop $ticket && docker rm $ticket && docker rmi 192.168.109.41:5000/liferay/com-liferay-forms:$ticket
else
    echo "invalid option."
fi
