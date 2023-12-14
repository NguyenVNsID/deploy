#!/bin/bash

package_name="ibus-unikey"

# if dpkg -l | grep -q "^ii.*$package_name" ; then
#     echo "$package_name is installed."
# else
#     echo "$package_name is not installed."
# fi

for app in "tmux" "ibus-unikey" "solaar" "gnome-tweaks"; do
    if apt list --installed | grep -q "^$app/" ; then
        echo "$app is installed."
    else
        echo "$app is not installed."
    fi
done