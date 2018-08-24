#!/bin/bash

container=$1

if [ -z $container ]
then
   echo "First argument should be the container's name"
   exit
fi
echo "stopping container... $container"

sudo docker stop $container
sudo docker rm $container 

