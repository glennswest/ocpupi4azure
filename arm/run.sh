#!/bin/bash

RESOURCE_GROUP_NAME=${1:-gswx1}

./setup_azarm.sh $RESOURCE_GROUP_NAME
read -p "Press [Enter] to start deploy"
./deploy_azarm.sh	$RESOURCE_GROUP_NAME
