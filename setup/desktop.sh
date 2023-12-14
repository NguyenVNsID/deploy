#!/bin/bash

#### SET ENVIRONMENT VARIABLE
# color
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
END_COLOR="\e[0m"

# user & group
USER="linux"
GROUP="linux"
PASSWORD='echo "$INPUT_PASS" |'

# file & directory
DIRECTORY=nnn1489 # option
DIRECTORY_LOG=/var/opt/log
FILE_NULL=/dev/null
FILE_RELEASE_INFO=/etc/os-release
FILE_ERROR=error.log
FILE_OK=ok.log

# networking
PING="8.8.8.8"

###############################################################################

#### DEFINED FUNCTION
# check exit code
check_exit_code_status() {
    if [ $? -ne 0 ]; then
        echo "$RED PLEASE RUN COMMAND: cat $DIRECTORY_LOG/$FILE_ERROR TO CHECK ERROR LOG!$END_COLOR"
    else
        echo "$GREEN COMMAND RUN SUCCESSFULLY!$END_COLOR"
    fi
}

# deploy for os is debian or based-on debian
deploy_for_os_using_apt () {
    echo "DEPLOYING WITH APT PACKAGE MANAGEMENT"

    for option in "update" "upgrade" "dist-upgrade" "autoremove"; do
        echo "---> RUNNING COMMAND: $GREEN sudo apt $option -y $END_COLOR"
        eval "$PASSWORD sudo -S apt $option -y 1>> $DIRECTORY_LOG/$FILE_OK 2>> $DIRECTORY_LOG/$FILE_ERROR"
        check_exit_code_status
    done

    # tmux vim ibus-unikey git snapd net-tools openssh-server xz-utils at sshpass python3-pip ncdu solaar gnome-tweaks (use to when close screen, computer still run)
    for app in "tmux" "ibus-unikey" "solaar" "gnome-tweaks"; do
        echo "---> CHECKING $app EXISTS ON THE SYSTEM OR NOT?"

        if apt list --installed | grep -q "^$app/"; then
            echo "$GREEN THE $app IS INSTALLED.$END_COLOR"
        else
            echo "THE$YELLOW $app $END_COLOR IS NOT INSTALLED."
            echo "---> RUNNING COMMAND: $GREEN sudo apt install -y $app $END_COLOR"
            eval "echo $PASSWORD sudo -S apt install -y $app 1>> $DIRECTORY_LOG/$FILE_OK 2>> $DIRECTORY_LOG/$FILE_ERROR"
            check_exit_code_status
        fi
    done
}

# deploy_apps_use_snap () {

# }

# deploy_apps_use_flathub () {
    
# }

# deploy_apps_from_official () {
    
# }

###############################################################################

#### DEPLOYMENT
# enter password to automatically install
echo -n "ENTER YOUR PASSWORD: "
stty -echo
read INPUT_PASS
stty echo
echo    # newline

# create new directory inside user directory (option)
echo "---> CREATING $DIRECTORY DIRECTORY INSIDE /home/$USER...."
eval "$PASSWORD sudo -S mkdir -p /home/$USER/$DIRECTORY"
echo "$GREEN CREATED $DIRECTORY DIRECTORY INSIDE /home/$USER $END_COLOR."

# checking network
echo "---> CHECKING NETWORK: PING TO $PING...."

if ping -c 1 "$PING" 1>> $DIRECTORY_LOG/$FILE_OK; then
    sleep 1
    echo "$GREEN NETWORK CONNECTION STATUS: OK!$END_COLOR"
else
    echo "$RED NETWORK CONNECTION STATUS: NG!$END_COLOR"
    echo "$RED PLEASE CHECK NETWORK ON THIS SYSTEM!$END_COLOR"
    exit 1
fi

# create file to write log ok, log error message during installation
eval "$PASSWORD sudo -S mkdir -p $DIRECTORY_LOG"
eval "$PASSWORD sudo -S touch $DIRECTORY_LOG/$FILE_OK $DIRECTORY_LOG/$FILE_ERROR"
eval "$PASSWORD sudo -S chown -R $USER:$GROUP $DIRECTORY_LOG"

# check distrobution info to select package management to deploy
# ???? toi uu phan nay, su dung for loop
echo "---> CHECKING PACKAGE MANAGEMENT TO DEPLOY FROM $FILE_RELEASE_INFO...."
if  grep -q "Pop" $FILE_RELEASE_INFO || grep -q "Ubuntu" $FILE_RELEASE_INFO || grep -q "Lubuntu" $FILE_RELEASE_INFO; then
    deploy_for_os_using_apt
else
    echo "$RED NOT FOUND \"Pop\" OR \"Ubuntu\" INSIDE $FILE_RELEASE_INFO $END_COLOR"
    exit 1
fi

#### LOOKING FOR SOLUTIONS FOR THIS IMPLEMENTATION WAY
# distributions=("Pop" "Ubuntu" "Lubuntu")
# if grep -q -e "${distributions[@]}" "$FILE_RELEASE_INFO"; then
#     echo "---> RUNNING COMMAND: $GREEN sudo apt update -y $END_COLOR"
#     eval "$PASSWORD sudo -S apt update -y 1>> $FILE_NULL 2>> $DIRECTORY_LOG/$FILE_ERROR"
#     check_exit_code_status
# else
#     echo "$RED NOT FOUND in (${distributions[@]}) INSIDE $FILE_RELEASE_INFO $END_COLOR"
#     exit 1
# fi

# # MAKE UBUNTU FASTER
# # remove language-related ign from apt update
# echo 'Acquire::Languages "none";' >> /etc/apt/apt.conf.d/00aptitude