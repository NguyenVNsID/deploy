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
PASSWORD='echo $INPUT_PASS'

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
deploy_software_use_apt () {
    echo "---> DEPLOYING WITH APT PACKAGE MANAGEMENT"

    options='
        update
        upgrade
        dist-upgrade
        autoremove
    '

    for option in $options; do
        echo "---> RUNNING COMMAND: $GREEN sudo apt $option -y $END_COLOR"
        eval "$PASSWORD | sudo -S apt $option -y 1>> $DIRECTORY_LOG/$FILE_OK 2>> $DIRECTORY_LOG/$FILE_ERROR"
        check_exit_code_status
    done

    # vim net-tools openssh-server xz-utils at sshpass python3-pip ncdu 
    # NOTE: gnome-tweaks (use to when close screen, computer still run)
    apps='
        git
        snap
        tmux
        solaar
        ibus-unikey
        gnome-tweaks
        flatpak
        gnome-software-plugin-flatpak
    '
    
    for app in $apps; do
        echo "---> CHECKING $app EXISTS ON THE SYSTEM OR NOT?"

        if apt list --installed | grep -q "^$app/"; then
            echo "$GREEN THE $app IS INSTALLED.$END_COLOR"
        else
            echo "$YELLOW THE $app IS NOT INSTALLED.$END_COLOR"
            echo "---> RUNNING COMMAND: $GREEN sudo apt install -y $app $END_COLOR"
            eval "$PASSWORD | sudo -S apt install -y $app 1>> $DIRECTORY_LOG/$FILE_OK 2>> $DIRECTORY_LOG/$FILE_ERROR"
            check_exit_code_status
        fi
    done
}

# install snap app use --classic flag
deploy_software_use_flag_option () {
    echo "---> RUNNING COMMAND: $GREEN sudo snap install $app --classic $END_COLOR"
    eval "$PASSWORD | sudo -S snap install $app --classic 1>> $DIRECTORY_LOG/$FILE_OK 2>> $DIRECTORY_LOG/$FILE_ERROR"
    check_exit_code_status
}

# install apps from snap
deploy_software_use_snap () {
    # NOTE: app use flag --classic: nvim, code
    # TIPS: applications that use flag --classic, should be put at the top inside the array to increase performance
    apps='
        nvim
        code
        curl
        spotify
    '
    
    for app in $apps; do
        echo "---> CHECKING $app EXISTS ON THE SYSTEM OR NOT?"

        if snap list --all | grep -q "$app"; then
            echo "$GREEN THE $app IS INSTALLED.$END_COLOR"
        else
            echo "$YELLOW THE $app IS NOT INSTALLED.$END_COLOR"
            
            if [ "$app" = "nvim" ]; then
                deploy_software_use_flag_option
            elif [ "$app" = "code" ]; then
                deploy_software_use_flag_option
            else
                echo "---> RUNNING COMMAND: $GREEN sudo snap install $app $END_COLOR"
                eval "$PASSWORD | sudo -S snap install $app 1>> $DIRECTORY_LOG/$FILE_OK 2>> $DIRECTORY_LOG/$FILE_ERROR"
                check_exit_code_status
            fi    
        fi
    done
}

# install apps from flathub
deploy_software_use_flathub () {
    apps='
        com.brave.Browser
        com.spotify.Client
        org.flameshot.Flameshot
        org.libreoffice.LibreOffice
        com.google.Chrome
        org.videolan.VLC
        org.ferdium.Ferdium
        io.dbeaver.DBeaverCommunity
        com.github.unrud.VideoDownloader
    '

    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    for app in $apps; do
        echo "---> CHECKING $app EXISTS ON THE SYSTEM OR NOT?"

        if flatpak list | grep -q "$app"; then
            echo "$GREEN THE $app IS INSTALLED.$END_COLOR"
        else
            echo "---> RUNNING COMMAND: $GREEN sudo -S flatpak install flathub -y $app $END_COLOR"
            eval "$PASSWORD | sudo -S flatpak install flathub -y $app 1>> $DIRECTORY_LOG/$FILE_OK 2>> $DIRECTORY_LOG/$FILE_ERROR"
            check_exit_code_status
        fi
    done
}

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
eval "$PASSWORD | sudo -S mkdir -p /home/$USER/$DIRECTORY"
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
eval "$PASSWORD | sudo -S mkdir -p $DIRECTORY_LOG"
eval "$PASSWORD | sudo -S touch $DIRECTORY_LOG/$FILE_OK $DIRECTORY_LOG/$FILE_ERROR"
eval "$PASSWORD | sudo -S chown -R $USER:$GROUP $DIRECTORY_LOG"

# check distrobution info to select package management to deploy
echo "---> CHECKING PACKAGE MANAGEMENT TO DEPLOY FROM $FILE_RELEASE_INFO...."

distros='
    "Pop"
    "Lubuntu"
    "Ubuntu"
'

for distro in $distros; do
    if grep -q -e "$distro" "$FILE_RELEASE_INFO"; then
        deploy_software_use_apt
        deploy_software_use_snap
        deploy_software_use_flathub
        break
    else
        echo "$RED NOT FOUND $distro INSIDE $FILE_RELEASE_INFO $END_COLOR"
        # exit 1
    fi
done

# # MAKE UBUNTU FASTER
# # remove language-related ign from apt update
# echo 'Acquire::Languages "none";' >> /etc/apt/apt.conf.d/00aptitude