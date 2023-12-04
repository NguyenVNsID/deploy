#!/bin/bash
# COLOR ENV
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
END_COLOR="\e[0m"

# TIME ENV
YYYYMMDD=`date +%Y%m%d`
YYYYMMDD_HM=`date +%Y%m%d_%H%M`

# FILES & DIRECTORIES ENV
FILE="test.txt"
NEW_SOURCE_BE=/opt/newsource/service_rest_api
NEW_SOURCE_SSH=/opt/newsource/service_rest_api

# GROUP & USER ENV
USER="psp"
GROUP="psp"

# OTHER ENV
IP="10.120.10.21"
SCRIPT="/opt/deploy/17.service.order-api.sh"

# -----------------------------------------------------------------------------

# DEPLOY
if [ whoami != "$USER" ];
then
    echo "You must run this script by user $USER!"
    exit 0
else
    ssh $USER@$IP mkdir -p $NEW_SOURCE_SSH/$YYYYMMDD/
    sleep 2

    scp $NEW_SOURCE_BE/$YYYYMMDD/$FILE $USER@$IP:$NEW_SOURCE_SSH/$YYYYMMDD/
    sleep 2

    ssh $USER@$IP sh $SCRIPT
    sleep 2
    
    #ssh psp@$IP tail -f /var/log/psp-hub/webtrade-service/webtrade-service.log
    echo -e "\e[1;33m Plese check log to: ssh psp@$IP tail -f /var/log/psp-hub/webtrade-service/webtrade-service.log \e[0m"
    sleep 2
fi