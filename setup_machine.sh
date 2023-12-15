# COMFIRM SETUP AFTER CHOOSE "Y" OR "N"
while read -p "---> DO YOU WANT TO CONTINUE RUN THIS SCRIPT? (Y or N): " choose; do
    if [ "$choose" == "y" ] || [ "$choose" == "Y" ]; then
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

# APT
# - curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -

# APPIMAGE
# - balenaEtcher

# - root: Nodejs, duplicati, 

# - reseach network tools nload, bmon, iptraf, nethogs

# - backup folder user, download, file .bashrc. vm virtual
# - export data broswer
# - save files script at the path `usr/local/bin`





# FOR CLIENT
flatpak-i com.brave.Browser com.spotify.Client org.flameshot.Flameshot org.libreoffice.LibreOffice com.google.Chrome org.videolan.VLC org.ferdium.Ferdium io.dbeaver.DBeaverCommunity com.github.unrud.VideoDownloader
snap-i  
apt-i tmux vim ibus-unikey git snapd net-tools openssh-server xz-utils at sshpass python3-pip ncdu solaar gnome-tweaks (use to when close screen, computer still run)
app image: VirtualBox
root: docker

# FOR SERVER
vim tmux htop docker git curl net-tools openssh-server xz-utils at sshpass python3-pip ncdu
