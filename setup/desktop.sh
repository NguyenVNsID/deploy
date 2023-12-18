#!/bin/bash
# * CAC PHAN MEM NAY PHAI DUOC CAI TRUOC TIEN
#### APT
        # apt-transport-https *
        # ca-certificates *
        # git
        # snap *
        # tmux
        # solaar
        # docker
        # ibus-unikey
        # gnome-tweaks
        # virtualbox
        # flatpak *
        # gnome-software-plugin-flatpak *
        # python3

#### SNAP & FLATPAK
        # brave
        # spotify
        # flameshot
        # libreoffice
        # vlc
        # ferdium
        # dbeaver
        # Video Downloader
        # nvim
        # code
        # KCalc
        # obs studio

#### FLATPAK
        # google

#### SNAP
        # node
        # curl *

###############################################################################
#### SET ENVIRONMENT VARIABLE
# script name
SCRIPT_NAME="desktop.sh"

# color
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
END_COLOR="\e[0m"

# user & group
USER="linux"
GROUP="linux"
PASSWORD='echo $INPUT_PASS'

# file & directory
DIRECTORY=nnn1489 # option
DIRECTORY_LOG=/var/opt/log
FILE_NULL=/dev/null
FILE_RELEASE_INFO=/etc/os-release
FILE_ERROR=error.log
FILE_OK=ok.log
FILE_SUDO=/etc/sudoers

# networking
PING="8.8.8.8"

###############################################################################
#### DEFINED FUNCTION
check_exit_code_status() {
    if [ $? -ne 0 ]; then
        echo "$RED PLEASE RUN COMMAND: cat $DIRECTORY_LOG/$FILE_ERROR TO CHECK ERROR LOG!$END_COLOR"
    else
        echo "$GREEN COMMAND RUN SUCCESSFULLY!$END_COLOR"
    fi
}

check_and_update_after_deployed_app_use_apt() {
    options='
        upgrade
        dist-upgrade
        full-upgrade
        autoremove
    '

    echo "---> CHECKING & UPDATING AFTER DEPLOYED SOFTWARE USE APT PACKAGES." 

    for option in $options; do
        echo "---> RUNNING COMMAND: $GREEN sudo apt $option -y $END_COLOR"
        sudo -S apt $option -y 1>> $DIRECTORY_LOG/$FILE_OK 2>> $DIRECTORY_LOG/$FILE_ERROR
        check_exit_code_status
    done

    sudo apt list --upgradable | awk '{ print $1 }' | grep '/' | cut -d'/' -f1 |

    while read -r PACKAGE_NAME; do
        echo "---> RUNNING COMMAND: $GREEN sudo apt upgrade -y $PACKAGE_NAME $END_COLOR"
        sudo apt upgrade -y $PACKAGE_NAME 1>> $FILE_OK 2>> $FILE_ERROR
        check_exit_code_status
    done
    
    echo "$GREEN COMPLETE PROCESS DEPLOY SOFTWARE USE APT PACKAGES!$END_COLOR"
}

test_with_exit_code_is_0 () {
    echo "$YELLOW YOU ARE TESTING YOUR CODE WITH EXIT CODE IS 0$END_COLOR"
    exit 0
}

test_with_exit_code_is_1 () {
    echo "$YELLOW YOU ARE TESTING YOUR CODE WITH EXIT CODE IS 1$END_COLOR"
    exit 1
}

deploy_software_use_apt () {
    # deploy for os is debian or based-on debian
    echo "---> DEPLOYING WITH APT PACKAGE MANAGEMENT"
    echo "---> RUNNING COMMAND: $GREEN sudo apt update -y $END_COLOR"
    sudo apt update -y 1>> $DIRECTORY_LOG/$FILE_OK 2>> $DIRECTORY_LOG/$FILE_ERROR
    check_exit_code_status
    check_and_update_after_deployed_app_use_apt

    # vim net-tools openssh-server xz-utils at sshpass python3-pip ncdu 
    # NOTE: gnome-tweaks (use to when close screen, computer still run)
    apps='
        snap
        flatpak
        gnome-software-plugin-flatpak
        virtualbox
    '

    for app in $apps; do
        echo "---> CHECKING $GREEN $app $END_COLOR EXISTS ON THE SYSTEM OR NOT?"

        if apt list --installed | grep -q "^$app/"; then
            echo "$GREEN $app APPLICATION HAS BEEN INSTALLED.$END_COLOR"
        else
            echo "$YELLOW $app APPLICATION IS NOT INSTALLED.$END_COLOR"
            echo "---> RUNNING COMMAND: $GREEN sudo apt install -y $app $END_COLOR"
            sudo apt install -y $app 1>> $DIRECTORY_LOG/$FILE_OK 2>> $DIRECTORY_LOG/$FILE_ERROR
            check_exit_code_status
            check_and_update_after_deployed_app_use_apt
        fi
    done
}

deploy_software_use_snap () {
    # NOTE: app use flag --classic: nvim, code
    # TIPS: applications that use flag --classic, should be put at the top inside the array to increase performance
    apps='
        nvim
    '

    for app in $apps; do
        echo "---> CHECKING $GREEN $app $END_COLOR EXISTS ON THE SYSTEM OR NOT?"

        if snap list --all | grep -q "$app"; then
            echo "$GREEN $app APPLICATION HAS BEEN INSTALLED.$END_COLOR"
        else
            echo "$YELLOW $app APPLICATION IS NOT INSTALLED.$END_COLOR"
            
            if [ "$app" = "nvim" ]; then
                deploy_software_use_snap_1flag
            elif [ "$app" = "code" ]; then
                deploy_software_use_snap_1flag
            elif [ "$app" = "node" ];then
                deploy_software_use_snap_2flag
            else
                echo "---> RUNNING COMMAND: $GREEN sudo snap install $app $END_COLOR"
                sudo snap install $app 1>> $DIRECTORY_LOG/$FILE_OK 2>> $DIRECTORY_LOG/$FILE_ERROR
                check_exit_code_status
            fi    
        fi
    done
}

deploy_software_use_snap_1flag () {
    echo "---> RUNNING COMMAND: $GREEN sudo snap install $app --classic $END_COLOR"
    sudo snap install $app --classic 1>> $DIRECTORY_LOG/$FILE_OK 2>> $DIRECTORY_LOG/$FILE_ERROR
    check_exit_code_status
}

deploy_software_use_snap_2flag () {
    echo "---> RUNNING COMMAND: $GREEN sudo snap install $app --edge --classic $END_COLOR"
    sudo snap install $app --edge --classic 1>> $DIRECTORY_LOG/$FILE_OK 2>> $DIRECTORY_LOG/$FILE_ERROR
    check_exit_code_status
}

deploy_software_use_flathub () {
    apps='
        com.brave.Browser
    '

    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    for app in $apps; do
        echo "---> CHECKING $GREEN $app $END_COLOR EXISTS ON THE SYSTEM OR NOT?"

        if flatpak list | grep -q "$app"; then
            echo "$GREEN $app APPLICATION HAS BEEN INSTALLED.$END_COLOR"
        else
            echo "$YELLOW $app APPLICATION IS NOT INSTALLED.$END_COLOR"
            echo "---> RUNNING COMMAND: $GREEN sudo flatpak install flathub -y $app $END_COLOR"
            sudo flatpak install flathub -y $app 1>> $DIRECTORY_LOG/$FILE_OK 2>> $DIRECTORY_LOG/$FILE_ERROR
            check_exit_code_status
        fi
    done
}

delete_software_default_use_apt () {
    # trien khai doi tuong de thu thi xoa app mac dinh tren nhieu ban phan phoi
    apps='
        libreoffice
        aisleriot
        cheese
        shotwell
        transmission
        gnome-mahjongg
        gnome-mines
        gnome-sudoku
        gnome-todo
        libgnome-todo
        remmina
        gnome-calculator
        gnome-calendar
    '

    echo "---> DELETING SOFTWARES DEFAULT...."

    for app in $apps; do
        echo "---> RUNNING COMMAND: $GREEN sudo apt purge -y $app* $PACKAGE_NAME $END_COLOR"
        sudo apt purge -y $app* 1>> $FILE_OK 2>> $FILE_ERROR
        check_exit_code_status

        echo "---> CHECKING & UPDATING SYSTEM AFTER DELETED $GREEN $app $END_COLOR...."
        sudo apt autoremove -y 1>> $FILE_OK 2>> $FILE_ERROR
        check_exit_code_status
    done

    echo "---> DELETED SOFTWARES DEFAULT"
}

###############################################################################

#### DEPLOYMENT
# enter password to automatically install
echo -n "ENTER YOUR PASSWORD: "
stty -echo
read INPUT_PASS
stty echo
echo    # newline

# checking user can execute commands with sudo permission
echo "---> CHECKING $GREEN$(whoami)$END_COLOR USER CAN EXECUTE COMMANDS WITH SUDO PERMISSION...."

sudo -l 1>> $FILE_OK 2>> $FILE_ERROR

if [ $? -eq 0 ]; then
    echo "$GREEN $(whoami) USER CAN RUN COMMANDS ON THIS SYSTEM WITH SUDO PERMISSION.$END_COLOR"
else    
    echo "$RED $(whoami) USER CANNOT RUN COMMANDS ON THIS SYSTEM WITH SUDO PERMISSION$END_COLOR"
    echo "---> REFER TO THE FOLLOWING INSTRUCTIONS TO ADD $GREEN $USER $END_COLOR USER INTO $FILE_SUDO FILE."
    echo "---> RUN COMMAND $GREEN su root $END_COLOR AND ENTER PASSWORD"
    echo "---> NEXT, RUN COMMAND $GREEN echo '$USER     ALL=(ALL:ALL) ALL' >> $FILE_SUDO $END_COLOR"
    echo "---> END, RUN COMMAND $GREEN exit $END_COLOR TO EXIT ROOT SESSION"
    echo "---> AFTER ALL THAT, PLEASE RE-RUN $GREEN $SCRIPT_NAME $END_COLOR FILE"
fi

# create file to write log ok, log error message during installation
sudo mkdir -p $DIRECTORY_LOG
sudo touch $DIRECTORY_LOG/$FILE_OK $DIRECTORY_LOG/$FILE_ERROR
sudo chown -R $USER:$GROUP $DIRECTORY_LOG

# create new directory inside user directory (option)
echo "---> CREATING $GREEN $DIRECTORY $END_COLOR DIRECTORY INSIDE PATH /home/$USER...."
sudo mkdir -p /home/$USER/$DIRECTORY
echo "$GREEN CREATED $DIRECTORY DIRECTORY INSIDE /home/$USER $END_COLOR."

# checking network
echo "---> CHECKING NETWORK: PING TO $GREEN $PING $END_COLOR...."

if ping -c 1 "$PING" 1>> $DIRECTORY_LOG/$FILE_OK; then
    sleep 1
    echo "$GREEN NETWORK CONNECTION STATUS: OK!$END_COLOR"
else
    echo "$RED NETWORK CONNECTION STATUS: NG!$END_COLOR"
    echo "$RED PLEASE CHECK NETWORK ON THIS SYSTEM!$END_COLOR"
    exit 1
fi

# check distrobution info to select package management to deploy
echo "---> CHECKING DISTRO INFO FROM $GREEN $FILE_RELEASE_INFO $END_COLOR FILE TO PREPARE DEPLOY...."

distros='
    "Ubuntu"
    "Pop"
    "Lubuntu"
'

for distro in $distros; do
    if grep -q -e "$distro" "$FILE_RELEASE_INFO"; then
        delete_software_default_use_apt
        deploy_software_use_apt
        deploy_software_use_snap
        deploy_software_use_flathub
        break
    else
        echo "$RED NOT FOUND $distro INSIDE $FILE_RELEASE_INFO $END_COLOR"
        # comment tam de test script
        # exit 1
    fi
done

# # MAKE UBUNTU FASTER
# # remove language-related ign from apt update
# echo 'Acquire::Languages "none";' >> /etc/apt/apt.conf.d/00aptitude