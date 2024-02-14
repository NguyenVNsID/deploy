#!/bin/bash

# SET ENVIRONMENT VARIABLE
# user & group
USER="linux"
GROUP="linux"

# color
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
END_COLOR='\e[0m'

# file & directory
DIRECTORY=vnn1489
DIRECTORY_LOG=/var/opt/log
FILE_NULL=/dev/null
FILE_RELEASE_INFO=/etc/os-release
FILE_ERROR=error.log
FILE_SUDO=/etc/sudoers

# DEFINED FUNCTION
check_error() {
    if [ $? -ne 0 ]; then
        echo "--> $RED run command 'cat $DIRECTORY_LOG/$FILE_ERROR' to check error log! $END_COLOR"
    fi
}

update_app_apt() {
    options='
        upgrade
        dist-upgrade
        full-upgrade
        autoremove
    '

    for option in $options; do
        sudo -S apt $option -y 1>> $FILE_NULL 2>> $DIRECTORY_LOG/$FILE_ERROR
        check_error
    done

    sudo apt list --upgradable | awk '{ print $1 }' | grep '/' | cut -d'/' -f1 |

    while read -r PACKAGE_NAME; do
        sudo apt upgrade -y $PACKAGE_NAME 1>> $FILE_NULL 2>> $FILE_ERROR
        check_error
    done
}

install_app_apt () {
    sudo apt update -y 1>> $FILE_NULL 2>> $DIRECTORY_LOG/$FILE_ERROR
    check_error
    update_app_apt

    # APT: python3, net-tools, openssh-server, xz-utils, at, sshpass, python3-pip, bat

    apps='
        curl
        apt-transport-https
        ca-certificates
        snap
        flatpak
        gnome-software-plugin-flatpak
        git
        solaar
        ibus-unikey
        gnome-tweaks
    '

    for app in $apps; do
        if apt list --installed | grep -q "^$app/"; then
            return
        else
            echo "--> installing $app ...."
            sudo apt install -y $app 1>> $FILE_NULL 2>> $DIRECTORY_LOG/$FILE_ERROR            
            check_error
            update_app_apt
        fi
    done
}

install_app_snap () {
   apps='
        brave
        spotify
        flameshot
        libreoffice
        vlc
        ferdium
        dbeaver-ce
        video-downloader
        kcalc
        nmap 
        code
        node
    '

    for app in $apps; do
        if snap list --all | grep -q "$app"; then
            echo "-->'$app' application has been installed."
        else
            if [ "$app" = "code" ]; then
                echo "--> installing $app ...."
                sudo snap install $app --classic 1>> $FILE_NULL 2>> $DIRECTORY_LOG/$FILE_ERROR
                check_error
            elif [ "$app" = "node" ];then
                echo "--> installing $app ...."
                sudo snap install $app --edge --classic 1>> $FILE_NULL 2>> $DIRECTORY_LOG/$FILE_ERROR
                check_error
            else
                echo "--> installing $app ...."
                sudo snap install $app 1>> $FILE_NULL 2>> $DIRECTORY_LOG/$FILE_ERROR
                check_error
            fi    
        fi
    done
}

install_app_flathub () {
    apps='
        com.google.Chrome
        com.obsproject.Studio
    '

    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    for app in $apps; do
        if flatpak list | grep -q "$app"; then
            echo "--> '$app' application has been installed."
        else
            echo "--> installing $app ...."
            sudo flatpak install flathub -y $app 1>> $FILE_NULL 2>> $DIRECTORY_LOG/$FILE_ERROR
            check_error
        fi
    done
}

delete_app_apt_default () {
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

    echo "--> deleting apps default...."

    for app in $apps; do
        sudo apt purge -y $app* 1>> $FILE_NULL 2>> $FILE_ERROR
        check_error
        sudo apt autoremove -y 1>> $FILE_NULL 2>> $FILE_ERROR
        check_error
    done
}

# DEPLOYMENT
# enter password to automatically install
stty -echo
stty echo
echo # newline

# checking user can execute commands with sudo permission
sudo -l 1>> $FILE_NULL 2>> $FILE_ERROR # ????

if [ $? -eq 0 ]; then
    echo "--> $YELLOW run command 'su root' $END_COLOR"
    echo "--> $YELLOW next, run command 'echo $USER     ALL=(ALL:ALL) ALL >> $FILE_SUDO' $END_COLOR"
    echo "--> $YELLOW end, run command 'exit' to exit root sesstion $END_COLOR"
    echo "--> $YELLOW after all that, re-run script file $END_COLOR"
fi

# create file to write log ok, log error message during installation
sudo mkdir -p $DIRECTORY_LOG
sudo touch $DIRECTORY_LOG/$FILE_ERROR
sudo chown -R $USER:$GROUP $DIRECTORY_LOG

# create new directory inside user directory (option)
sudo mkdir -p /home/$USER/$DIRECTORY

# check distrobution & install
distros='
    "Ubuntu"
    "Pop"
    "Lubuntu"
'

for distro in $distros; do
    if grep -q -e "$distro" "$FILE_RELEASE_INFO"; then
        delete_app_apt_default
        install_app_apt
        install_app_snap
        install_app_flathub
        echo "--> INSTALLED. run command $GREEN cat $DIRECTORY_LOG/$FILE_ERROR $END_COLOR to check error log."
        break
    else
        echo "--> $RED not found '$distro' inside '$FILE_RELEASE_INFO' $END_COLOR"
        exit 1
    fi
done
