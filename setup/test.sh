#!/bin/bash
############# SET ENVIRONMENT VARIABLE
# user & group
USER="linux"
GROUP="linux"

# file & directory
FILE_OK=ok.log
DIRECTORY=vnn1489
FILE_ERROR=error.log
FILE_SUDO=/etc/sudoers
DIRECTORY_LOG=/var/opt/log
FILE_RELEASE_INFO=/etc/os-release

############# DEFINE FUNCTION
config_git() {
    GIT_CONFIG=~/.gitconfig

    config() {

        git config --global user.name "vnn1489"
        git config --global user.email "vnn1489@outlook.com"
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
            sudo apt install -y $app 1>> $DIRECTORY_LOG/$FILE_OK 2>> $DIRECTORY_LOG/$FILE_ERROR            
            check_error
            update_app_apt
        fi
    done
}

install_app_snap () {
   # node
   # alternatives to flathub: brave, spotify, libreoffice, vlc, ferdium, dbeaver-ce, kcalc, arianna, flameshot (conflig with snap), video-downloader, nmap
   apps='
        curl
        code
    '

    echo "-------> installing apps with snap...."

    for app in $apps; do
        if snap list --all | grep -q "$app"; then
            echo "---> installed: $app"
        else
            if [ "$app" = "code" ]; then
                echo "---> installing $app...."
                sudo snap install $app --classic 1>> $DIRECTORY_LOG/$FILE_OK 2>> $DIRECTORY_LOG/$FILE_ERROR
                check_error
            elif [ "$app" = "node" ];then
                echo "---> installing $app...."
                sudo snap install $app --edge --classic 1>> $DIRECTORY_LOG/$FILE_OK 2>> $DIRECTORY_LOG/$FILE_ERROR
                check_error
            else
                echo "---> installing $app...."
                sudo snap install $app 1>> $DIRECTORY_LOG/$FILE_OK 2>> $DIRECTORY_LOG/$FILE_ERROR
                check_error
            fi    
        fi
    done
}

install_app_flathub () {
    apps='
        com.brave.Browser
        com.spotify.Client
        org.libreoffice.LibreOffice
        org.videolan.VLC
        org.ferdium.Ferdium
        io.dbeaver.DBeaverCommunity
        org.kde.kcalc
        org.kde.arianna
        org.flameshot.Flameshot
        com.obsproject.Studio
        com.google.Chrome
        io.github.pwr_solaar.solaar
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

delete_app_apt_default () {
    # libgnome-todo, gnome-todo (khong biet day co phai app anh huong toi phan khong co setting khong) 
    
    apps='
        rhythmbox
        thunderbird
        libreoffice
        aisleriot
        cheese
        shotwell
        transmission
        gnome-mahjongg
        gnome-mines
        gnome-sudoku
        remmina
        gnome-calculator
        gnome-calendar
    '

    echo "-------> deleting apps default...."

    for app in $apps; do
        echo "---> deleting $app...."
        sudo apt purge -y $app* 1>> $DIRECTORY_LOG/$FILE_OK 2>> $FILE_ERROR
        check_error
        sudo apt autoremove -y 1>> $DIRECTORY_LOG/$FILE_OK 2>> $FILE_ERROR
        check_error
    done
}

############# DEPLOYMENT
# checking user can execute commands with sudo permission

read -p "Enter your password: " password
echo "$password" | sudo -Sl # check user can run with sudo permission

if [ $? -ne 0 ]; then
    echo "---> run command: su root"
    echo "---> next, run command: echo '$USER     ALL=(ALL:ALL) ALL' >> $FILE_SUDO"
    echo "---> end, run command: exit"
    echo "---> after all that, re-run script file"
    exit 1
fi

# create file to write log ok, log error message during installation
sudo mkdir -p $DIRECTORY_LOG && cd $DIRECTORY_LOG
sudo touch $FILE_ERROR $FILE_OK
sudo chown -R $USER:$GROUP $DIRECTORY_LOG
echo "---> run command to view log: tail -f $DIRECTORY_LOG/$FILE_ERROR"
echo "---> run command to view log: tail -f $DIRECTORY_LOG/$FILE_OK"

# create new directory inside user directory (option)
sudo mkdir -p ~/$USER/$DIRECTORY
sudo mkdir -p ~/$USER/$DIRECTORY/local-repo
sudo chown -R $USER: ~/$USER/$DIRECTORY

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
sudo pip3 install thefuck --user 1>> $DIRECTORY_LOG/$FILE_OK 2>> $FILE_ERROR
sudo pip3 install thefuck --upgrade 1>> $DIRECTORY_LOG/$FILE_OK 2>> $FILE_ERROR

# .bashrc
echo "---> configing .bashrc file...."
wget https://github.com/vnn1489/deploy/raw/main/setup/desktop-bashrc -P ~/$USER/$DIRECTORY 1>> $DIRECTORY_LOG/$FILE_OK 2>> $FILE_ERROR
cd ~/$DIRECTORY && cat desktop-bashrc >> ~/.bashrc

echo "---> install apps manually: virtual box, docker, termius"