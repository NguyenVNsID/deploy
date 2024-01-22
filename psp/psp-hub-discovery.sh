#!/bin/bash
############# setup env #############
# color
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
END_COLOR='\e[0m'

# group & user
USER=psp

# time
YYYYMMDD=$(date +%Y%m%d)
YYYYMMDD_HM=$(date +%Y%m%d_%H%M)

# file & directory
SERVICE_NAME='discovery service'
SOURCE_NAME=discovery
SOURCE_CURRENT=/opt/01.PSP/03.Deploy/01.psp-hub/00.psp-discovery-api/source-deploy
SOURCE_BACKUP=/opt/03.Backups/$SOURCE_NAME
SOURCE_NEW=/home/psp/newsource/00.psp-hub/$SOURCE_NAME
SOURCE_FILE=discovery-service-1.0.0.jar
SOURCE_SPACE=/opt/01.PSP/02.MicroK8s/01.PSP-hub
CONFIG=psp-discovery-api.yaml

# docker
DOCKER_REPO=public.ecr.aws/y7a2a4q9/psp
DOCKER_IMAGE=psp-discovery-api-$YYYYMMDD_HM

############# run code #############
# check user
if [ $(whoami) != $USER ]; then
    echo "$RED --> You must run this script with '$USER' user. $END_COLOR"
    exit 1
fi

# check new source code exist
if [ -f $SOURCE_NEW/$YYYYMMDD/$SOURCE_FILE ]; then
    # check & create backup directory
    if [ -d $SOURCE_BACKUP/$YYYYMMDD ]; then
        mv $SOURCE_BACKUP/$YYYYMMDD/$SOURCE_FILE $SOURCE_BACKUP/$YYYYMMDD/$SOURCE_FILE.$YYYYMMDD_HM
        sleep 2
    else
        mkdir -p $SOURCE_BACKUP/$YYYYMMDD
    fi

    # deploy
    echo "$GREEN --> Deploy $SERVICE_NAME: Begin. $END_COLOR"

    mv $SOURCE_CURRENT/$SOURCE_FILE $SOURCE_BACKUP/$YYYYMMDD
    sleep 2

    cp $SOURCE_NEW/$YYYYMMDD/$SOURCE_FILE $SOURCE_CURRENT
    sleep 2

    cd /opt/01.PSP/03.Deploy/01.psp-hub/00.psp-discovery-api
    docker build -t $DOCKER_REPO:$DOCKER_IMAGE ./
    sleep 2

    sudo aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin $DOCKER_REPO
    docker push $DOCKER_REPO:$DOCKER_IMAGE
    sleep 2

    cd $SOURCE_SPACE
    vim -c ":%!sed 's|image: $DOCKER_REPO:psp-discovery-api-.*|image: $DOCKER_REPO:$DOCKER_IMAGE|'" -c "wq" $SOURCE_SPACE/$CONFIG
    microk8s kubectl apply -f $CONFIG
    sleep 2

    echo "--> --> Result md5sum of newsource is: $YELLOW $(sudo md5sum $SOURCE_CURRENT/$SOURCE_FILE | awk '{print $1}'). $END_COLOR"
    echo "--> --> Check status: $YELLOW microk8s kubectl get po -n psp-hub $END_COLOR"
    echo "--> --> Check resources: $YELLOW watch microk8s kubectl top po -n psp-hub $END_COLOR"

    echo "$GREEN --> Deploy $SERVICE_NAME: Done. $END_COLOR"
else
    echo "$RED --> New source not found! $END_COLOR"
fi