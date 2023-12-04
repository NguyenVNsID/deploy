#!/bin/bash
# COLOR ENV
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
END_COLOR="\e[0m"

# TIME ENV
DDMM="date +%d/%m"
YYYYMMDD=`date +%Y%m%d`
YYYYMMDD_HM=`date +%Y%m%d_%H%M`

# FILES & DIRECTORIES ENV
FILE="order-service-0.0.1.jar"
BACKUP=/opt/backups/order-api
SOURCE=/opt/deploy/source/module_0 # ????
NEW_SOURCE=/home/psp/newsource/order-api

# GROUP & USER ENV
USER="psp"
GROUP="psp"

# OTHER ENV
IP="10.120.10.21"
SCRIPT="/opt/deploy/17.service.order-api.sh"
SERVICE_NAME="Order Service"

# DEFINE FUNCTION BACKUP
backup_last() {
    echo "  $GREEN ---> Backup the deploy "$FILE" for the last time in $DDMM: Begin. $END_COLOR"
    sudo mv $BACKUP/$YYYYMMDD $BACKUP/$YYYYMMDD_HM
    sudo mkdir -p $BACKUP/$YYYYMMDD
    sudo chown -R $USER:$GROUP $BACKUP
    echo "  $GREEN ---> Backup the deploy "$FILE" for the last time in $DDMM: Done. $END_COLOR"
}

# -----------------------------------------------------------------------------

# DEPLOY
echo "$GREEN Deploy $SERVICE_NAME staging: Begin. $END_COLOR"

# CHECK USER CAN RUN SCRIPT
if [ `whoami` != "$USER" ]; then
    echo -e "$RED You must run this script by $USER $END_COLOR"
    exit 1 # ALL CODE BEHIND WILL NOT WORK IF EXIT CODE IS 1
else

# BACKUP CURRENT SOURCE
if [ -d "$BACKUP/$YYYYMMDD" ]; then
    backup_last

elif [ -f "$BACKUP/$YYYYMMDD/$FILE" ]; then
    backup_last

else
    sudo mkdir -p $BACKUP/$YYYYMMDD
    sudo chown -R $USER:$GROUP $BACKUP
    sleep 2
    echo "  $GREEN ---> Backup the deploy "$FILE" for the firts time in $DDMM: Begin. $END_COLOR"
    mv $SOURCE/$FILE $BACKUP/$YYYYMMDD/
    echo "  $GREEN ---> Backup the deploy "$FILE" for the firts time in $DDMM: Done. $END_COLOR"
fi

# GET NEW SOURCE
echo "  $GREEN ---> Copy new source: Begin. $END_COLOR"
cp $NEW_SOURCE/$YYYYMMDD/$FILE $SOURCE
echo "  $GREEN ---> Copy new source: Done. $END_COLOR"
sleep 2

sh /opt/psp-hub/04.psp-order-api/deploy.sh

echo "$GREEN Deploy $SERVICE_NAME staging: Done. $END_COLOR"