#!/bin/bash
############# feauture #############
# tail log service
# check status

############# set env #############
# color
GREEN='\e[32m'
RED='\e[31m'
YELLOW='\e[33m'
END_COLOR='\e[0m'

# group & user
USER=psp
GROUP=psp

# time
HHMM=$(date +%H%M)
YYYYMMDD=$(date +%Y%m%d)
YYYYMMDD_HM=$(date +%Y%m%d_%H%M)

# file & directory
SERVICE_NAME='discovery service'
SOURCE_CURRENT=/opt/01.PSP/03.Deploy/01.psp-hub/00.psp-discovery-api/source-deploy
SOURCE_BACKUP=/opt/03.Backups/discovery
SOURCE_NEW=/home/psp/newsource/00.psp-hub/discovery
SOURCE_FILE=discovery-service-1.0.0.jar
DOCKER_REPO=public.ecr.aws/y7a2a4q9/$USER # ????
IMAGE_NAME=psp-discovery-api-$YYYYMMDD_HM # ???? suggest DOCKER_IMAGE=psp-discovery-api-$YYYYMMDD_HM

############# run code #############
# check if the script is run by the 'psp' user
if [ $(whoami) != $USER ]; then
    echo "$RED You must run this script with '$USER' user. $END_COLOR"
    exit 1
fi

# check new source code exist
if [ -f $SOURCE_NEW/$YYYYMMDD/$SOURCE_FILE ]; then
    # check & create backup directory
    if [ -d $BACKUP/$YYYYMMDD ]; then
        echo "$GREEN Rename the current backup file. $END_COLOR"
        mv $SOURCE_BACKUP/$YYYYMMDD/$SOURCE_FILE $SOURCE_BACKUP/$YYYYMMDD/$SOURCE_FILE.$HHMM
    else
        mkdir -p $SOURCE_BACKUP/$YYYYMMDD
    fi

    # deploy
    echo "$GREEN Deploy $SERVICE_NAME: Begin. $END_COLOR"

    echo "---> Backup source code."
    mv $SOURCE_CURRENT/$SOURCE_FILE $SOURCE_BACKUP/$YYYYMMDD
    sleep 2

    echo "---> Copy new source."
    cp $SOURCE_NEW/$YYYYMMDD/$SOURCE_FILE $SOURCE_CURRENT/$SOURCE_FILE
    sleep 2

    echo "---> Build container from image."
    cd /opt/01.PSP/03.Deploy/01.psp-hub/00.psp-discovery-api
    docker build -t "$DOCKER_REPO:$IMAGE_NAME" .  # ???? can remove " | suggest: "." will use variable BUILD_PATH_CONTEXT
    sleep 2

    # ????
    sudo aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin "$DOCKER_REPO"
    docker push "$DOCKER_REPO:$IMAGE_NAME"
    sleep 2

    # ????
    cd /opt/01.PSP/02.MicroK8s/01.PSP-hub
    vim -c ":%!sed 's|image: $DOCKER_REPO:psp-discovery-api-.*|image: $DOCKER_REPO:$IMAGE_NAME|'" -c "wq" /opt/01.PSP/02.MicroK8s/01.PSP-hub/psp-discovery-api.yaml
    microk8s kubectl apply -f psp-discovery-api.yaml
    sleep 2

    echo "$GREEN Result md5sum of newsource is: $(sudo md5sum $SOURCE_CURRENT/$SOURCE_FILE | awk '{print $1}'). $END_COLOR"

    echo "$GREEN Deploy $SERVICE_NAME: Done. $END_COLOR"
else
    echo "$RED New source not found! $END_COLOR"
fi