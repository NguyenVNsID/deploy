#!/bin/bash

# Prompt user for password and store it securely
read -s -p "ENTER YOUR PASSWORD: " password
echo

# Your sudo commands go here
echo "$password" | sudo -S apt-get update -y
echo "$password" | sudo -S apt-get upgrade -y

# Additional commands as needed
