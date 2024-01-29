#!/bin/bash
# * CAC PHAN MEM NAY PHAI DUOC CAI TRUOC TIEN
#### APT
    # python3
    # net-tools
    # openssh-server
    # xz-utils
    # at
    # sshpass
    # python3-pip
    # bat

#### SET ENVIRONMENT VARIABLE ####

# user & group
USER="linux"
GROUP="linux"

# file & directory
DIRECTORY=vnn1489
DIRECTORY_LOG=/var/opt/log
FILE_NULL=/dev/null
FILE_RELEASE_INFO=/etc/os-release
FILE_ERROR=error.log
FILE_SUDO=/etc/sudoers

# networking
PING="8.8.8.8"

#### DEFINED FUNCTION ####
check_error() {
    if [ $? -ne 0 ]; then
        echo "--> --> please run command 'cat $DIRECTORY_LOG/$FILE_ERROR' to check error log!"
    fi
}

check_and_update_after_deployed_app_use_apt() {
    options='
        upgrade
        dist-upgrade
        full-upgrade
        autoremove
    '

    echo "--> --> --> checking & updating after deployed software use apt package management."

    for option in $options; do
        sudo -S apt $option -y 1>> $DIRECTORY_LOG/$FILE_NULL 2>> $DIRECTORY_LOG/$FILE_ERROR
        check_error
    done

    sudo apt list --upgradable | awk '{ print $1 }' | grep '/' | cut -d'/' -f1 |

    while read -r PACKAGE_NAME; do
        sudo apt upgrade -y $PACKAGE_NAME 1>> $FILE_NULL 2>> $FILE_ERROR
        check_error
    done
}

deploy_software_use_apt () {
    echo "--> deploying with apt package management"
    echo "--> --> running command 'sudo apt update -y'"
    sudo apt update -y 1>> $DIRECTORY_LOG/$FILE_NULL 2>> $DIRECTORY_LOG/$FILE_ERROR
    check_error
    check_and_update_after_deployed_app_use_apt

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
        echo "--> --> checking '$app' exists on the system or not?"

        if apt list --installed | grep -q "^$app/"; then
            echo "--> --> --> '$app' application has been installed."
        else
            echo "--> --> --> '$app' application is not installed."
            echo "--> --> --> running command 'sudo apt install -y $app'"
            sudo apt install -y $app 1>> $DIRECTORY_LOG/$FILE_NULL 2>> $DIRECTORY_LOG/$FILE_ERROR            
            check_error
            check_and_update_after_deployed_app_use_apt
        fi
    done
}

deploy_software_use_snap () {
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
        echo "--> checking '$app' exists on the system or not?"

        if snap list --all | grep -q "$app"; then
            echo "--> --> '$app' application has been installed."
        else
            echo "--> --> '$app' application is not installed"
            
            if [ "$app" = "code" ]; then
                echo "--> --> running command 'sudo snap install $app --classic'"
                sudo snap install $app --classic 1>> $DIRECTORY_LOG/$FILE_NULL 2>> $DIRECTORY_LOG/$FILE_ERROR
                check_error
            elif [ "$app" = "node" ];then
                echo "--> --> running command 'sudo snap install $app --edge --classic'"
                sudo snap install $app --edge --classic 1>> $DIRECTORY_LOG/$FILE_NULL 2>> $DIRECTORY_LOG/$FILE_ERROR
                check_error
            else
                echo "--> --> running command 'sudo snap install $app'"
                sudo snap install $app 1>> $DIRECTORY_LOG/$FILE_NULL 2>> $DIRECTORY_LOG/$FILE_ERROR
                check_error
            fi    
        fi
    done
}

deploy_software_use_flathub () {
    apps='
        com.google.Chrome
        com.obsproject.Studio
    '

    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    for app in $apps; do
        echo "--> checking '$app' exists on the system or not?"

        if flatpak list | grep -q "$app"; then
            echo "--> --> '$app' application has been installed."
        else
            echo "--> --> '$app' application is not installed"
            echo "--> --> running command 'sudo flatpak install flathub -y $app'"
            sudo flatpak install flathub -y $app 1>> $DIRECTORY_LOG/$FILE_NULL 2>> $DIRECTORY_LOG/$FILE_ERROR
            check_error
        fi
    done
}

delete_software_default_use_apt () {
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

    echo " --> deleting softwares default...."

    for app in $apps; do
        echo "--> --> running command: 'sudo apt purge -y $app* $PACKAGE_NAME" # ???? $PACKAGE_NAME meaning
        sudo apt purge -y $app* 1>> $FILE_NULL 2>> $FILE_ERROR
        check_error

        echo "--> --> checking & updating system after deleted '$app'...."
        sudo apt autoremove -y 1>> $FILE_NULL 2>> $FILE_ERROR
        check_error
    done
}

#### DEPLOYMENT ####
# enter password to automatically install
echo -n "--> enter your password: "
stty -echo
stty echo
echo # newline

# checking user can execute commands with sudo permission
echo "--> checking '$(whoami)' user can execute commands with sudo permission...."

sudo -l 1>> $FILE_NULL 2>> $FILE_ERROR # ????

if [ $? -eq 0 ]; then
    echo "--> --> '$(whoami)' user can run commands on this system with sudo permission."
else    
    echo "--> --> '$(whoami)' user can't run commands on this system with sudo permission"
    echo "--> --> refer to the following instructions to add '$USER' user into '$FILE_SUDO' file."
    echo "--> --> run command 'su root' and enter password"
    echo "--> --> next, run command 'echo $USER     ALL=(ALL:ALL) ALL >> $FILE_SUDO'"
    echo "--> --> end, run command 'exit' to exit root sesstion"
    echo "--> --> after all that, please re-run script file"
fi

# create file to write log ok, log error message during installation
sudo mkdir -p $DIRECTORY_LOG
sudo touch $DIRECTORY_LOG/$FILE_ERROR
sudo chown -R $USER:$GROUP $DIRECTORY_LOG

# create new directory inside user directory (option)
echo "--> creating '$DIRECTORY' directory inside path '/home/$USER'...."
sudo mkdir -p /home/$USER/$DIRECTORY

# checking network
echo "--> checking network: ping to '$PING'...."

if ping -c 1 "$PING" 1>> $DIRECTORY_LOG/$FILE_NULL; then
    sleep 1
    echo "--> --> network connection status: ok!"
else
    echo "--> --> network connection status: ng!"
    echo "--> --> please check network on this system!"
    exit 1
fi

# check distrobution info to select package management to deploy
echo "--> checking distro info from '$FILE_RELEASE_INFO' file to prepare deploy...."

distros='
    "Ubuntu"
    "Pop"
    "Lubuntu"
'

for distro in $distros; do
    if grep -q -e "$distro" "$FILE_RELEASE_INFO"; then
        echo "--> --> distro on this system is: '$distro'"
        delete_software_default_use_apt
        deploy_software_use_apt
        deploy_software_use_snap
        deploy_software_use_flathub
        echo "--> deploy process is completed."
        echo "--> please run command 'cat $DIRECTORY_LOG/$FILE_ERROR' to check error log."
        echo "--> or run command 'cat $DIRECTORY_LOG/$FILE_NULL' to check good log."
        break
    else
        echo "--> --> not found '$distro' inside '$FILE_RELEASE_INFO'"
        exit 1
    fi
done