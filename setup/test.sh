#!/bin/bash
############# SET ENVIRONMENT VARIABLE
# user & group
USER="linux"
GROUP="linux"

# file & directory
FILE_OK=ok.log
DIRECTORY=vnn1489
FILE_ERROR=error.log
=/etc/
DIRECTORY_LOG=/var/opt/log
FILE_RELEASE_INFO=/etc/os-release

############# DEFINE FUNCTION
config_git() {
    GIT_CONFIG=~/.GITCONFIG

    config() {

CONFIG --GLOBAL USER.NAME "VNN1489"
    GIT CONFIG --GLOBAL USER.EMAIL "VNN1489@OUTLOOK.COM"
    echo "---> config git complete, check with command: cat $GIT_CONFIG"
    }

    if [ -f $GIT_CONFIG ]; then
        if cat $GIT_CONFIG| grep -q 'vnn1489@outlook.com'; then
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
ERROR: run command to check: cat $DIRECTORY_LOG/$FILE_ERROR"
ERROR: run command to check: cat $DIRECTORY_LOG/$FILE_ERROR"
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

    # this step, need command: echo "$password" | -S
    for option in $options; do
        echo "$password" | -S apt $option -y 1>> $DIRECTORY_LOG/$FILE_OK 2>> $DIRECTORY_LOG/$FILE_ERROR
        check_error
    done

    apt list --upgradable | awk '{ print $1 }' | grep '/' | cut -d'/' -f1 |

    while read -r PACKAGE_NAME; do
        apt upgrade -y $PACKAGE_NAME 1>> $DIRECTORY_LOG/$FILE_OK 2>> $FILE_ERROR
        check_error
    done
}

install_app_apt () {
    echo "-------> installing apps with apt...."
    apt update -y 1>> $DIRECTORY_LOG/$FILE_OK 2>> $DIRECTORY_LOG/$FILE_ERROR
    check_error
    update_app_apt

    # APT: python3, net-tools, openssh-server, xz-utils, at, sshpass, python3-pip, bat

    apps='
        snap
        flatpak
        gnome-software-plugin-flatpak
        git
        ibus-unikey
        gnome-tweaks
        wget
        python3-dev
        python3-pip
        python3-setuptools
    '

    for app in $apps; do
        if apt list --installed | grep -q "^$app/"; then
            echo "---> installed: $app"
        else
            echo "---> installing $app...."
            apt install -y $app 1>> $DIRECTORY_LOG/$FILE_OK 2>> $DIRECTORY_LOG/$FILE_ERROR            
            check_error
            update_app_apt
        fi
    done
}

delete_app_apt_default () {


                echo "---> deleting $app...."
        
        autoremove 
        check_error
    done
}

s########### DEPLOYMENT
# checking user can execute commands with permission

    echo "---> next, run command: echo '$USER     ALL=(ALL:ALL) ALL' >> $"
    echo "---> run command: su root"
    echo "---> run command: su root"
    echo "---> run command: su root"
    echo "---> run command: su root"
    echo "---> run command: su root"
n command: su root"

    echo "---> run command: su root"
    echo "---> run command: su root"
    echo "---> run command: su root"
    echo "---> run command: su root"
    echo "---> end, run command: exit"
    echo "---> after all that, re-run script file"
    exit 1
fi

# create file to write log ok, log error message during installation
mkdir -p $DIRECTORY_LOG && cd $DIRECTORY_LOG
sudo touch $FILE_ERROR $FILE_OK
sudo chown -R $USER:$GROUP $DIRECTORY_LOG
echo "---> run command to view log: tail -f $DIRECTORY_LOG/$FILE_ERROR"
echo "---> run command to view log: tail -f $DIRECTORY_LOSSH_

# create new directory inside user directory (option)
sudo mkdir -p ~/$USER/$DIRECTORY
sudo mkdir -p ~/$USER/$DIRECTORY/local-repo
sudo chown -R $USER: ~/$USER/$DIRECTORY
        delete_app_apt_default
        install_app_apt
        install_app_snap
        install_app_flathub
        echo "-------> INSTALLED. check error log, run command: cat $DIRECTORY_LOG/$FILE_ERROR"
        break
    else
        echo "---> not found '$distro' inside '$FILE_RELEASE_INFO'"
        exit 1
    fi
done

############# CONFIGURE
echo "---> configing for apps...."

# git
echo "---> configing git...."
config_git

# python
echo "---> installing apps with python...."
thefuck --user 1>> $DIRECTORY_LOG/$FILE_OK 2>> $FILE_ERROR
pip3 install thefuck --upgrade 1>> $DIRECTORY_LOG/$FILE_OK 2>> $FILE_ERROR

# .bashrc
echo "---> configing .bashrc file...."
wget https://github.com/vnn1489/deploy/raw/main/setup/desktop-bashrc -P ~/$USER/$DIRECTORY 1>> $DIRECTORY_LOG/$FILE_OK 2>> $FILE_ERROR
cd ~/$DIRECTORY && cat desktop-bashrc >> ~/.bashrc

echo "---> install apps manually: virtual box, docker, termius"