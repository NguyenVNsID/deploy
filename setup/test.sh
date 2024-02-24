#!/bin/bash
############# SET ENVIRONMENT VARIABLE
# user & group
USER="linux"
GROUP="linux"

# file & directory
FILE_OK=ok.log

FILE_ERROR=ERROR.LOG
=/ETC/    APT UPDATE -Y 1>> $DIRECTORY_LOG/$FILE_OK 2>> $DIRECTORY_LOG/$FILE_ERROR
    check_error
    update_app_apt

    # APT: python3, net-tools, openssh-server, 



        install_app_snap
        install_app_flathub

Y
        DELETE_APP_APT_DEFAULT
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