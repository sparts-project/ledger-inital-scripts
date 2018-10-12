#!/bin/bash
CONTAINER=$1

if [ -z $CONTAINER ]
then
   echo "error - usage: $0 [CONTAINER name]"
   exit
fi

echo "stopping container '$CONTAINER' (if already running)..."
sudo docker stop $CONTAINER > /dev/null  
sudo docker rm $CONTAINER > /dev/null 

## Use the following command to get the latest version of the ledger node
echo "Check for latest version of container '$CONTAINER'..."
sudo docker pull sameerfarooq/sparts-test:$CONTAINER 

echo "spinning up containter: $CONTAINER..."
sudo docker run -dit --name=$CONTAINER -p 0.0.0.0:818:818 -p 0.0.0.0:4004:4004 -p 127.0.0.1:8080:8080 -p 127.0.0.1:8800:8800 sameerfarooq/sparts-test:$CONTAINER 
sudo docker exec -it $CONTAINER /project/sparts_ledger.sh

echo "Waiting for container to intialize..."
sleep 10s
echo "Sending test ping request to container..."
curl -i http://0.0.0.0:818/ledger/api/v1/ping
echo
echo "Creating initial user (bootstrapping first user)..."
## Need to initialize the very first user (only one time via register_init command).
sudo docker exec -ti $CONTAINER sh -c "user register_init 02be88bd24003b714a731566e45d24bf68f89ede629ae6f0aa5ce33baddc2a0515 johndoe john.doe@windriver.com allow admin"
