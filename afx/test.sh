#!/bin/bash
# # check to make sure the user has entered exactly two arguments.
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


# run_command() {
#     local cmd="$1"
#     local line="$2"
    
#     # Run the command
#     $cmd
    
#     # Check the exit code
#     if [ $? -ne 0 ]; then
#         echo "Command on line $line failed with exit code $?."
#     fi
# }

# # Example usage:
# line_number=$(($LINENO + 1))  # Increment by 1 to get the line number of the next command
# run_command "ls /nonexistent_directory" $line_number
# line_number=$(($LINENO + 1))
# run_command "echo 'Hello, World!'" $line_number



#!/bin/bash

# Run the sha256sum command and store its output in a variable
checksum_output=$(sha256sum /opt/deploy/backup/module_0/20230919/monkeytype.zip)

# Extract only the checksum part using awk
checksum_code=$(echo "$checksum_output" | awk '{print $1}')

# Print the checksum code
echo "SHA256 Checksum: $checksum_code"






