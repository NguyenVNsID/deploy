#!/bin/bash
#### SET COMMON ENVIRONMENT VARIABLE
# color
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
END_COLOR="\e[0m"
PASSWORD='echo "$INPUT_PASS" |'
LOG_PATH=/var/opt/log
USERNAME="linux"
PING="www.google.com"

#### DEFINED FUNCTION
check_exit_code_status() {
    if [ $? -ne 0 ]; then
        echo "$RED PLEASE RUN COMMAND: cat $ERROR_PATH TO CHECK ERROR LOG!$END_COLOR"
    fi
}

###############################################################################

#### DEPLOYMENT
# enter password to automatically install
echo -n "ENTER YOUR PASSWORD: "
stty -echo
read INPUT_PASS
stty echo
echo    # this is just for a newline after entering the password

# check user can run script
echo "---> CHECKING $USERNAME USER CAN DO THIS SCRIPT"

if [ `whoami` != $USERNAME ]; then
    echo "$RED YOU MUST RUN THIS SCRIPT BY $USERNAME USER $END_COLOR"
    exit 1
else
    echo "$GREEN THIS SCRIPT RUN BY $USERNAME USER $END_COLOR"
fi

# checking network
echo "---> CHECKING INTERNET CONNECTION...."

if ping -c 1 "$PING" >> /dev/null; then
    sleep 1
    echo "$GREEN INTERNET CONNECTION: OK!$END_COLOR"
else
    echo "$RED INTERNET CONNECTION: NG!$END_COLOR"
    echo "$YELLOW PLEASE CHECK NETWORK ON THIS SYSTEM!$END_COLOR"
    exit 1
fi

# check system to choose package management
# distribution info
RELEASE_INFO=/etc/os-release 
    #0 check file release of some one distribution popular


eval "$PASSWORD sudo mkdir -p $LOG_PATH"
eval "$PASSWORD sudo touch -p $LOG_PATH/error.log"
eval "$PASSWORD sudo chmod +w $LOG_PATH/error.log"

if  grep -q "Pop" $RELEASE_INFO || grep -q "Ubuntu" $RELEASE_INFO; then
    echo "---> RUNNING COMMAND $GREEN sudo apt update -y $END_COLOR"
    eval "$PASSWORD sudo -S apt update -y 1>> /dev/null 2>> $LOG_PATH/error.log"
    check_exit_code_status
fi











# # Use sudo with -S option to read the password from standard input
# echo "---> RUNNING COMMAND$GREEN sudo apt update -y$END_COLOR"
# eval "$PASSWORD sudo -S apt update -y >> /dev/null"







# # MAKE UBUNTU FASTER
# # remove language-related ign from apt update
# echo 'Acquire::Languages "none";' >> /etc/apt/apt.conf.d/00aptitude