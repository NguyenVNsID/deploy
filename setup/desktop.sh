#!/bin/bash
#### SET ENVIRONMENT VARIABLE
# color
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
END_COLOR="\e[0m"

USER="linux"
GROUP="linux"
PASSWORD='echo "$INPUT_PASS" |'

#fiel & directory
LOG_PATH=/var/opt/log
RELEASE_INFO=/etc/os-release
ERROR_FILE=error.log
NULL_PATH=/dev/null

# networking
PING="www.google.com"

# list
options=(
    "update"
    "upgrade"
    "dist-upgrade"
    "autoremove"
)


#### DEFINED FUNCTION
# check exit code
check_exit_code_status() {
    if [ $? -ne 0 ]; then
        echo "$RED PLEASE RUN COMMAND: cat $LOG_PATH/$ERROR_FILE TO CHECK ERROR LOG!$END_COLOR"
    else
        echo "$GREEN THE COMMAND RUN SUCCESSFULLY!$END_COLOR"
    fi
}

# deploy for os is debian or based-on debian
deploy_for_os_using_apt () {
    # options=("update" "upgrade" "dist-upgrade" "autoremove")

    # echo "---> RUNNING COMMAND:$GREEN sudo apt $OPTIONS -y $END_COLOR"
    # eval "$PASSWORD sudo -S apt $OPTIONS -y 1>> $NULL_PATH 2>> $LOG_PATH/$ERROR_FILE"
    # check_exit_code_status

    for option in "${options[@]}"; do
        echo "---> RUNNING COMMAND: $GREEN sudo apt $option -y $END_COLOR"
        eval "echo $password | sudo -S apt $option -y 1>> $NULL_PATH 2>> $LOG_PATH/$ERROR_FILE"
        check_exit_code_status
    done



    # tmux vim ibus-unikey git snapd net-tools openssh-server xz-utils at sshpass python3-pip ncdu solaar gnome-tweaks (use to when close screen, computer still run)
    # apps=( "tmux" "ibus-unikey" "solaar" "gnome-tweaks" )

    # echo "---> RUNNING COMMAND:$GREEN sudo apt install -y  $END_COLOR"
    # eval "$PASSWORD sudo -S apt install ???? -y 1>> $NULL_PATH 2>> $LOG_PATH/$ERROR_FILE"
    # check_exit_code_status
}

deploy_apps_use_snap () {

}

deploy_apps_use_flathub () {
    
}

deploy_apps_from_official () {
    
}


###############################################################################

#### DEPLOYMENT
# enter password to automatically install
echo -n "ENTER YOUR PASSWORD: "
stty -echo
read INPUT_PASS
stty echo
echo    # this is just for a newline after entering the password

# checking network
echo "---> CHECKING INTERNET CONNECTION...."

if ping -c 1 "$PING" 1>> $NULL_PATH; then
    sleep 1
    echo "$GREEN INTERNET CONNECTION: OK!$END_COLOR"
else
    echo "$RED INTERNET CONNECTION: NG!$END_COLOR"
    echo "$YELLOW PLEASE CHECK NETWORK ON THIS SYSTEM!$END_COLOR"
    exit 1
fi

# create file to write log error message during installation
eval "$PASSWORD sudo -S mkdir -p $LOG_PATH"
eval "$PASSWORD sudo -S touch $LOG_PATH/$ERROR_FILE"
eval "$PASSWORD sudo -S chown -R $USER: $LOG_PATH"

# check distrobution info
echo "---> CHECKING DISTRIBUTION INFO INSIDE $RELEASE_INFO...."

if  grep -q "Pop" $RELEASE_INFO || grep -q "Ubuntu" $RELEASE_INFO || grep -q "Lubuntu" $RELEASE_INFO; then
    deploy_for_os_using_apt
else
    echo "$RED NOT FOUND \"Pop\" OR \"Ubuntu\" INSIDE $RELEASE_INFO $END_COLOR"
    exit 1
fi

#### LOOKING FOR SOLUTIONS FOR THIS IMPLEMENTATION WAY
# distributions=("Pop" "Ubuntu" "Lubuntu")
# if grep -q -e "${distributions[@]}" "$RELEASE_INFO"; then
#     echo "---> RUNNING COMMAND: $GREEN sudo apt update -y $END_COLOR"
#     eval "$PASSWORD sudo -S apt update -y 1>> $NULL_PATH 2>> $LOG_PATH/$ERROR_FILE"
#     check_exit_code_status
# else
#     echo "$RED NOT FOUND in (${distributions[@]}) INSIDE $RELEASE_INFO $END_COLOR"
#     exit 1
# fi


# # Use sudo with -S option to read the password from standard input
# echo "---> RUNNING COMMAND$GREEN sudo apt update -y$END_COLOR"
# eval "$PASSWORD sudo -S apt update -y >> /dev/null"


# # MAKE UBUNTU FASTER
# # remove language-related ign from apt update
# echo 'Acquire::Languages "none";' >> /etc/apt/apt.conf.d/00aptitude