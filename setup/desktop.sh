#!/bin/bash
############# SET ENVIRONMENT VARIABLE
# user & group
USER="linux"
GROUP="linux"

# file & directory
FILE_OK=ok.log
FILE_ERROR=error.log
DIRECTORY_LOG=/var/opt/log

############# DEFINE FUNCTION
config_git() {
    GIT_CONFIG=~/.gitconfig

    config() {
        git config --global user.name "vnn1489"
        git config --global user.email "vnn1489@outlook.com"
        echo "---> config git complete, check with command: cat $GIT_CONFIG"
    }

    if [ -f $GIT_CONFIG ]; then
        if cat $GIT_CONFIG | grep -q 'vnn1489@outlook.com'; then
            echo "---> existed info user"
        else
            config
        fi
    else
        config
    fi
}

check_error() {
    if [ $? -ne 0 ]; then
        echo "-------> ERROR: run command to check: cat $DIRECTORY_LOG/$FILE_ERROR"
    fi
}

check_ssh_key() {
    SSH_KEY=~/.ssh/id_rsa
    
    if [ -f $SSH_KEY ]; then
        echo "---> add content of 'id_rsa.pub' to github, etc."
    else
        ssh-keygen -t rsa -N "" -f "$SSH_KEY" -q 1>> $DIRECTORY_LOG/$FILE_OK 2>> $FILE_ERROR
    fi
}

update_app_apt() {
    options='
        upgrade
        dist-upgrade
        full-upgrade
        autoremove
    '

    # this step, need command: echo "$password" | sudo -S
    for option in $options; do
        echo "$password" | sudo -S apt $option -y 1>> $DIRECTORY_LOG/$FILE_OK 2>> $DIRECTORY_LOG/$FILE_ERROR
        check_error
    done

    sudo apt list --upgradable | awk '{ print $1 }' | grep '/' | cut -d'/' -f1 |

    while read -r PACKAGE_NAME; do
        sudo apt upgrade -y $PACKAGE_NAME 1>> $DIRECTORY_LOG/$FILE_OK 2>> $FILE_ERROR
        check_error
    done
}

install_app_apt () {
    echo "-------> installing apps with apt...."
    sudo apt update -y 1>> $DIRECTORY_LOG/$FILE_OK 2>> $DIRECTORY_LOG/$FILE_ERROR
    update_app_apt
    
    apps='
        snap
        flatpak
        gnome-software-plugin-flatpak
        git
        ibus-unikey
        gnome-tweaks
    '

    for app in $apps; do
        if apt list --installed | grep -q "^$app/"; then
            echo "---> installed: $app"
        else
            echo "---> installing $app...."
            sudo apt install -y $app 1>> $DIRECTORY_LOG/$FILE_OK 2>> $DIRECTORY_LOG/$FILE_ERROR            
            check_error
            update_app_apt
        fi
    done
}

install_app_snap () {
   apps='
        figma-linux
    '

    echo "-------> installing apps with snap...."

    for app in $apps; do
        if snap list --all | grep -q "$app"; then
            echo "---> installed: $app"
        else
            echo "---> installing $app...."
            sudo snap install $app 1>> $DIRECTORY_LOG/$FILE_OK 2>> $DIRECTORY_LOG/$FILE_ERROR
            check_error   
        fi
    done
}

install_app_flathub () {
    apps='
        com.brave.Browser
        com.spotify.Client
        org.libreoffice.LibreOffice
        org.ferdium.Ferdium
        org.kde.arianna
        org.flameshot.Flameshot
        com.google.Chrome
        com.github.tchx84.Flatseal
        com.visualstudio.code
    '

    echo "-------> installing apps with flathub...."

    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    for app in $apps; do
        if flatpak list | grep -q "$app"; then
            echo "---> installed: $app"
        else
            echo "---> installing $app...."
            sudo flatpak install flathub -y $app 1>> $DIRECTORY_LOG/$FILE_OK 2>> $DIRECTORY_LOG/$FILE_ERROR
            check_error
        fi
    done
}

############# DEPLOYMENT
# checking user can execute commands with sudo permission
read -p "Enter your password: " password
echo "$password" | sudo -Sl # check user can run with sudo permission

# create file to write log ok, log error message during installation
sudo mkdir -p $DIRECTORY_LOG
cd $DIRECTORY_LOG
sudo touch $FILE_ERROR $FILE_OK
sudo chown -R $USER:$GROUP $DIRECTORY_LOG
echo "---> run command to view log: tail -f $DIRECTORY_LOG/$FILE_ERROR"
echo "---> run command to view log: tail -f $DIRECTORY_LOG/$FILE_OK"

install_app_apt
install_app_snap
install_app_flathub

############# CONFIGURE
# git
echo "---> configing git...."
config_git

# set bashrc for all users
echo "---> configing .bashrc file...."
wget https://github.com/vnn1489/deploy/raw/main/setup/desktop-bashrc -P /tmp 1>> $DIRECTORY_LOG/$FILE_OK 2>> $FILE_ERROR
sudo bash -c 'cat /tmp/desktop-bashrc >> /etc/bash.bashrc'
