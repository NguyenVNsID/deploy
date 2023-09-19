#!/bin/bash

# COLOR
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
END_COLOR="\e[0m"

# TIME
YYYYMMDD=`date +%Y%m%d`
YYYYMMDD_HM=`date +%Y%m%d_%H%M`

# FILES & DIRECTORIES
BACKUP=/opt/deploy/backup/module_0
SOURCE=/opt/deploy/source/module_0
NEW_SOURCE=/opt/deploy/new_source/module_0
FILE_OR_DIRECTORY=monkeytype
FILE_ZIP=monkeytype.zip

# CHECKSUM
sum_backup=""
sum_source=""
sum_new_source=""

# GROUP & USER
USER="ubuntu"
GROUP="ubuntu"

# FUNCTION TO GET NUMBER LINE, WHERE THE COMMAND ERROR OCCURS
cli_error() {
    local line="$1"
    local command="$2"
    echo "Error on line $line: $command"
    exit 1
}

trap 'cli_error $LINENO "$BASH_COMMAND"' ERR # TRAP ANY NON-ZERO EXIT CODES AND LOG THEM

#CHECK USER CAN RUN
if [ `whoami` != "$USER" ]; then
    echo -e "YOU MUST RUN THIS SCRIPT BY $GREEN $USER $END_COLOR USER."
    exit 1
fi

# CHECK & CREATE BACKUP DIRECTORY
if [ -d "$BACKUP/$YYYYMMDD" ]; then
    sudo mv $BACKUP/$YYYYMMDD $BACKUP/$YYYYMMDD_HM
    sudo mkdir -p $BACKUP/$YYYYMMDD
    sudo chown -R $USER:$GROUP $BACKUP
else
    sudo mkdir -p $BACKUP/$YYYYMMDD
    sudo chown -R $USER:$GROUP $BACKUP
fi

# DEPLOY
echo "$GREEN DEPLOY BACKEND ODOO STAGING: BEGIN. $END_COLOR"

if [ -e "$NEW_SOURCE/$FILE_ZIP" ]; then
    # BACKUP
    echo "   $GREEN ---> BACKUP CURRENT SOURCE. $END_COLOR"
    sudo zip -r $FILE_ZIP $SOURCE/$FILE_OR_DIRECTORY >> /dev/null
    sum_source=$(sha256sum $SOURCE/$FILE_ZIP | awk '{print $1}')
    sudo cp $SOURCE/$FILE_ZIP $BACKUP/$YYYYMMDD
    sum_backup=$(sha256sum $BACKUP/$YYYYMMDD/$FILE_ZIP | awk '{print $1}')

    if [ "$sum_source" = "$sum_backup" ]; then
        sudo rm -rf $SOURCE/$FILE_OR_DIRECTORY
        sudo rm $SOURCE/$FILE_ZIP
        echo "      CHECKSUM: OK"
        break
    else
        echo "      CHECKSUM: NG"
        exit 1
    fi

    break  

else
    rm -rf $SOURCE/$FILE_ZIP
    echo "PLEASE CHECK NEW SOURCE AGAIN"
    exit 1
fi

# GET NEW SOURCE
echo "   $GREEN ---> GET NEW SOURCE. $END_COLOR"
sum_new_source=$(sha256sum $NEW_SOURCE/$FILE_ZIP | awk '{print $1}')
sudo cp -rf $NEW_SOURCE/$FILE_ZIP $SOURCE
sum_source=$(sha256sum $SOURCE/$FILE_ZIP | awk '{print $1}')

if [ "$sum_source" = "$sum_new_source" ]; then
    echo "111"
    sudo unzip $SOURCE/$FILE_ZIP # >> /dev/null
    echo "222"
    sudo rm -rf $SOURCE/$FILE_ZIP
    echo "333"
    sudo chown -R $USER:$GROUP $SOURCE
    echo "      CHECK SUM: OK"
    break
else
    echo "      CHECK SUM: NG"
    exit 1
fi   
    
echo "   $GREEN ---> RESTART SERVICE. $END_COLOR"
sleep 4

echo "$GREEN DEPLOY BACKEND ODOO STAGING: DONE. $END_COLOR"
sleep 1