#!/bin/bash
# UBUNRU DESKTOP
Ubuntu Software Center
Software & Updates >>>> OTHER SOFTWARE >>>> IGNORE


sudo du -sh /var/cache/apt 

sudo apt-get autoremove

# Either remove only the outdated packages, like those superseded by a recent update
sudo apt-get autoclean

# Or delete apt cache in its entirety (frees more disk space):
sudo apt-get clean

# DELETE LOGS OF 3 DAY
sudo journalctl --vacuum-time=3d

# DELETE LOGS OF ALL DAY
sudo journalctl --vacuum-time=0

# du -sh ~/.cache/thumbnails
rm -rf ~/.cache/thumbnails/*


# du -h /var/lib/snapd/snaps ---> TO CHECK
# Removes old revisions of snaps
# CLOSE ALL SNAPS BEFORE RUNNING THIS
set -eu
snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        snap remove "$snapname" --revision="$revision"
    done





# Find and remove duplicate files
FDUPES ---> cli

#