#!/bin/bash
#CHECK CONNECTION TO THE INTERNET OR SERVER LOCAL
PING="www.google.com"

echo "---> CHECKING INTERNET CONNECTION...."

if ping -c 1 "$PING" &> /dev/null; then
    sleep 1
    echo "---> INTERNET CONNECTION: OK"
else
    echo "---> INTERNET CONNECTION: NG"
    echo "---> PLEASE CHECK ON THIS SYSTEM!"
    exit 1
fi

# COMFIRM SETUP AFTER CHOOSE "Y" OR "N"
while read -p "---> DO YOU WANT TO CONTINUE RUN THIS SCRIPT? (Y or N): " choose; do

    if [ "$choose" == "y" ] || [ "$choose" == "Y" ];then
        number=4
        while [ "$number" -ge 0 ]; do
            echo -ne "\rSYSTEM WILL SETUP AFTER $number SECONDS. "
            sleep 1
            ((number--))
        done
        break

    elif [ "$choose" == "n" ] || [ "$choose" == "N" ];then
        echo "---> SEE YOU AGAIN IN THE NEXT TIME SETUP ON THIS SYSTEM!"
        break

    else
        echo "---> PLEASE TYPE \"Y\" OR \"N\""
        continue
    fi

done

# CHECK SYSTEM TO CHOOSE PACKAGE MANAGEMENT
release_file=/etc/os-release


# CODE OF CQTDT ASIA
# SETUP ENV FOR GLOBAL
TIME_0=`date +Y%m%d`
TIME_1=`date +Y%m%d_%H%M%S`



# CHECK USER CAN RUN SCRIPT
if [ `whoami` != "UserName" ]; then
    echo -e "\e[1;33m YOU MUST RUN THIS SCRIPT BY UserName USER \e[0m"
    exit 0 ---> cho nay nghi la phai exit 1 thi phai
else




# number=10

# echo "Countdown starting..."

# while [ "$number" -ge 0 ]; do
#     echo -ne "\rSYSTEM WILL SETUP AFTER $number SECONDS. "
#     sleep 1
#     ((number--))
# done

# echo -e "\nSystem setup complete!"





# release_file=/etc/os-release
# ok_logs=/var/log/my_system_logs/ok.log
# error_logs=/var/log/my_system_logs/error.log

# check_exit_status() {
#     if [ $? -ne 0 ]; then
#         echo "PLEASE CHECK <---$error_logs---> FILE!"
#     fi
# }

# if grep -q "Arch" $release_file; then
#     sudo pacman -Syu 1>> $ok_logs 2>> $error_logs
#     check_exit_status
# fi

# if grep -q "Pop" $release_file || grep -q "Ubuntu" $release_file
#     then
#     sudo apt update -y 1>> $ok_logs 2>> $error_logs
#     check_exit_status

#     sudo apt dist-upgrade -y 1>> $ok_logs 2>> $error_logs
#     check_exit_status
# fi


# <--- case --->
# echo "PLEASE HELP ME CHOOSE \"Y\" OR \"N\""

# read choose;

# case $choose in
#     y) echo "y";;
#     Y) echo "Y";;
#     n) echo "n";;
#     N) echo "N";;
# esac


# ARGUMENTS
# line=$(ls -lh $1 | wc -l)

# if [ $# -ne 1 ]; then
#         echo "this is script requires exactly one directory path passed to it."
#         echo "please try again."
#         exit 1
# fi

# echo "you have $(($line - 1)) object in the <--- $1---> directory."

# check to make sure the user has entered exactly two arguments.
# if [ $# -ne 2 ]; then
#     echo "usage: backup.sh <source_directory> <target_directory>"
#     echo "please try again."
#     exit 1
# fi

# # check to see if rsyns is installed.
# if !command -v rsync > /dev/null 2>&1; then
#     echo "this script requires rsync to bo intalled."
#     echo "please use your distrobution's package manager to install it and try again."
#     exit 2
# fi

# # capture the current date, and store it in the format yyyy-mm-dd
# current_date=$(date +%Y-%m-%d)

# rsync_opt="-avd --backup-dir $2/$current_date --delete" # --dry-run

# $(which rsync) $rsync_opt $1 $2/current >> backup_$current_date.log


# -------------------------------------------------------------------------------------
# PREPROCESS
# sudo apt update -y
# sudo add-apt-repository ppa:appimagelaunche
# sudo apt update -y



# APT
# - curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -

# - with deb: ferdium

# - apti curl tmux vim ibus-unikey git snapd gh curl flameshot net-tools openssh-server xz-utils at sshpass libreoffice python3-pip solaar ncdu appimagelauncher

# code virtualbox-7.0 spotify-client

# manual: code, spotify, brave

# APPIMAGE
# - balenaEtcher

# - root: Nodejs, duplicati, 

# - reseach network tools nload, bmon, iptraf, nethogs

# - backup folder user, download, file .bashrc. vm virtual
# - export data broswer
# - save files script at the path `usr/local/bin`


# - update && upgrade
# - download file alias and save at folder user >>> push content of alias into .bashrc file
# - tmux: download file config from github and save at user folder
# - spotify: curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
# echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list && sudo apt update -y && sudo apt install -y spotify-client
# ##


# SCRIPT
# sudo apt update -y && sudo apt upgrade -y
# sudo apt install 


# SPOTIFY
# curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg

# echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

# echo "pretreatment for spotify: done"

# BRAVE
# sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

# echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

# echo "pretreatment for brave: done"

# FOR CLIENT
flatpak-i com.brave.Browser com.spotify.Client org.flameshot.Flameshot org.libreoffice.LibreOffice com.google.Chrome org.videolan.VLC
snap-i docker code codium
apt-i tmux vim curl ibus-unikey git snapd curl net-tools openssh-server xz-utils at sshpass python3-pip ncdu solaar gnome-tweaks (use to when close screen, computer still run)
app image: VirtualBox

# FOR SERVER
vim tmux htop docker curl git curl net-tools openssh-server xz-utils at sshpass python3-pip ncdu
