#!/bin/bash

# time
YYYYMMDD=`date +Y%m%d`
YYYYMMDD_HM=`date +Y%m%d_%H%M` # 2

# color
GREEN="\e[32m"
BLUE="\e[34m"
RED="\e[31m"
YELLOW="\e[33m"
END_COLOR="\e[0m"

# user & group
USER="psp"
GROUP="psp"

# file & directory
NULL=/dev/null
SOURCE_CURRENT="/opt/01.PSP/03.Deploy/01.psp-hub/00.psp-discovery-api/source-deploy/" # SOURCE
SOURCE_NEW="/home/psp/newsource/00.psp-hub/discovery" # NEWDIR
SOURCE_BACKUP="/opt/03.Backups/discovery" # BACKDIR
SOURCE_NAME="discovery-service-1.0.0.jar" # FILE
DOCKER_REPO="public.ecr.aws/y7a2a4q9/$USER"
IMAGE_NAME="psp-discovery-api-$YYYYMMDD_HM"

# Check if the script is run by the 'psp' user
if [ `whoami` != $USER ]; then
    echo  "$RED You must run this script as the user '$USER'.$END_COLOR"
    exit 1
else
    
# Check if the new source file exists
if [ -f "$SOURCE_NEW/$YYYYMMDD/$SOURCE_NAME" ]; then
fi

        # Check and create the backup directory
        if [ -d "$BACKDIR/$DATE" ]; then
            mv "$BACKDIR/$DATE/$FILE" "$BACKDIR/$DATE/$FILE"_"$DATE_2"
        else
            mkdir -p "$BACKDIR/$DATE"
        fi

        # Deploy Discovery Service
        echo  "\e[1;33m Deploy Discovery Service: Begin .................................... \e[0m"
        mv "$SOURCE/$FILE" "$BACKDIR/$DATE/"
        sleep 2
        cp "$NEWDIR/$DATE/$FILE" "$SOURCE/$FILE"
        sleep 2
        cd /opt/01.PSP/03.Deploy/01.psp-hub/00.psp-discovery-api
        docker build -t "$DOCKER_REPO:$IMAGE_NAME" .
        sleep 2
        sudo aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin "$DOCKER_REPO"
        docker push "$DOCKER_REPO:$IMAGE_NAME"
        sleep 2
        cd /opt/01.PSP/02.MicroK8s/01.PSP-hub
        vim -c ":%!sed 's|image: $DOCKER_REPO:psp-discovery-api-.*|image: $DOCKER_REPO:$IMAGE_NAME|'" -c "wq" /opt/01.PSP/02.MicroK8s/01.PSP-hub/psp-discovery-api.yaml
        microk8s kubectl apply -f psp-discovery-api.yaml
        sleep 2
        echo  "\e[1;33m Deploy Discovery Service: Done ..................................... \e[0m"

        # Check MD5SUM newsource
        echo "\e[1;33m MD5SUM newcode $(sudo md5sum $SOURCE/$FILE | awk '{print $1}') \e[0m"
    else
        echo "Deploy Fail: New source not found!"
        exit 1
    fi


