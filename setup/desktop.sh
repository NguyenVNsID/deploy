#!/bin/bash
#### SET COMMON ENVIRONMENT VARIABLE
# color
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
END_COLOR="\e[0m"

###############################################################################

#### DEPLOYMENT
# enter password to automatically install
PASSWORD='echo "$password" |'
echo -n "Enter your password: "
stty -echo
read password
stty echo
echo    # this is just for a newline after entering the password

# checking networking
PING="www.google.com"

echo "---> CHECKING INTERNET CONNECTION...."

if ping -c 1 "$PING" &> /dev/null; then
    sleep 1
    echo -e "$GREEN    INTERNET CONNECTION: OK!$END_COLOR"
else
    echo -e "$RED   INTERNET CONNECTION: NG!$END_COLOR"
    echo -e "$YELLOW   PLEASE CHECK NETWORK ON THIS SYSTEM!$END_COLOR"
    exit 1
fi

# # check system to choose package management
# # distribution info
# RELEASE_INFO=/etc/os-release
#     #0 check file release of some one distribution popular
#     eval "$PASSWORD sudo -S apt update -y"











# # MAKE UBUNTU FASTER
# # remove language-related ign from apt update
# echo 'Acquire::Languages "none";' >> /etc/apt/apt.conf.d/00aptitude