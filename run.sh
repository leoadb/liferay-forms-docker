#!/bin/sh

read -p 'What is the ticket number: ' ticket

echo 'Where do you want to pull the Docker image?'
echo '1 - Local (default)'
echo '2 - Docker Hub (external)'
read repository

if [ -z "$repository" ]; then
  repository=1
fi

container=$(docker ps -a | grep "$ticket" | wc -l)

if [ $container -eq 1 ]; then
  docker kill $ticket
  docker rm -f $ticket
fi

if [ $repository -eq 1 ]; then
  docker pull 192.168.109.41:5000/liferay/com-liferay-forms:$ticket
  docker run -d -p 0:8080 --name $ticket 192.168.109.41:5000/liferay/com-liferay-forms:$ticket
elif [ $repository -eq 2 ]; then
  docker pull liferay/com-liferay-forms-qa:$ticket
  docker run -d -p 0:8080 --name $ticket liferay/com-liferay-forms-qa:$ticket
fi

function findPort(){
  docker port $ticket >> tempText.txt
  sed 's/.\{19\}//' tempText.txt >> tempText2.txt
}

function removeTempText(){
  rm -rf tempText.txt tempText2.txt
}

container2=$(docker ps -a | grep "$ticket" | wc -l)

if [ $container2 -eq 1 ]; then
  findPort
  echo ""
  echo "You can access your docker by the url: "
  echo "http://localhost"$(cat tempText2.txt)
  echo ""
  removeTempText

  echo 'Your docker will be listed below:'
  docker ps -a | grep $ticket
fi
