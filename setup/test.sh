#!/bin/bash

# List upgradable packages
upgradable_packages=$(sudo apt list --upgradable | grep -oP '\S+\/\S+' | grep -v -E 'Listing|Done')

# Upgrade all upgradable packages
sudo apt upgrade -y

# Install upgradable packages
sudo apt install -y $upgradable_packages
fdsfdsfsdfdsf
