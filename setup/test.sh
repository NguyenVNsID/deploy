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

#
    while read -r PACKAGE_NAME; do
        apt upgrade -y $PACKAGE_NAME 1>> 
}

{
...."
    apt update -y 1>> $DIRECTORY_LOG/$FILE_OK 2>> $DIRECTORY_LOG/$FILE_ERROR
    check_error
    update_app_apt

    # APT: python3, net-tools, openssh-server, 

 ss; do
 
cho "---> nstalled: $ap
       ELSE
            echo "---
> $DIRECTORY_LOG/$FILE_OK 2>> $DIRECTORY_LOG/$FILE_ERROR            
            check_error
_c
        fi
    done
}



########### DEPLOYMENT
ser can execute commands with permission


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
install thefuck --upgrade 1>> $DIRECTORY_LOG/$FILE_OK 2>> $FILE_ERROR

        # .bashrc
        echo "---> configing .bashrc file...."
        wget https://github.com/vnn1489/deploy/raw/main/setup/desktop-bashrc -P ~/$USER/$DIRECTORY 1>> $DIRECTORY_LOG/$FILE_OK 2>> $FILE_ERROR
cd ~/$DIRECTORY && cat desktop-bashrc >> ~/.bashrc

ECHO "---> INSTALL APPS MANUALLY: VIRTUAL BOX, DOCKER, TERMIUS"