#!/bin/bash
# IDEA: checksum

GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
END_COLOR="\e[0m"

YYYYMMDD=`date +Y%m%d`
YYYYMMDD_HM=`date +Y%m%d_%H%M`
SCRIPT_DIRECTORY="/home/ubuntu/vnn1489/programming/bash/afx"


modules=(
    "00.afx_backend_odoo"
    "01.afx_front_kyc_api"
    "02.afx_front"
    "03.afx_api"
    "04.afx_batch_all"
    "05.afx_batch_lmc"
    "06.afx_batch_report"
    "07.afx_regis"
)

# DEFINE FUNCTION
deploy_new_source() {

    while true; do
        read -p "PLEASE CHOOSE ITEM YOU WANT TO DEPLOY (ITEM: 00, 01, 02, ...): " input
        if [[ "$input" =~ ^[0-9]{2}$ ]]; then
            found=false

            # CHECK SCRIPT HAVE EXISTED INSIDE ARRAY
            for module in "${modules[@]}"; do
                module_number="${module%%.*}"  # Extract the module number

                if [ "$module_number" == "$input" ]; then
                    found=true
                    break
                fi
            done

            # SCRIPT EXISTED
            if [ "$found" = true ]; then
                while read -p "DO YOU WANT TO DEPLOY MODULE $(echo -e $GREEN $module $END_COLOR) WITH NEW SOURCE? (Y OR N): " choose; do
                    if [ "$choose" == "y" ] || [ "$choose" == "Y" ];then
                        sh $SCRIPT_DIRECTORY/$module.sh
                        break

                    elif [ "$choose" == "n" ] || [ "$choose" == "N" ];then
                        echo "---> SEE YOU AGAIN IN THE NEXT TIME DEPLOY!"
                        break

                    else
                        echo "---> PLEASE TYPE \"Y\" OR \"N\""
                        continue
                    fi
                done
                break
            
            # SCRIPT NOT EXISTED
            else
                echo "MODULE DEPLOY STARTING \"$input\" DOES NOT EXIST."
            fi

        else
            echo "PLEASE RE-ENTER (00, 01, 02, ...)"
            continue
        fi
    done
}

deploy_old_source() {
    echo "deploy old source"
}

all_module() {
    for module in "${modules[@]}"; do
        echo -e "$GREEN $module $END_COLOR"
    done
}


# START RUN SCRIPT
echo "<------------- GUIDE TO DEPLOY AFX STAGING ------------->"
echo "---> THIS SCRIPT WAS DESIGNED & CODED BY MY ASSOCIATES, CHATGPT & ME"
echo "---> WE RECOMMEND YOU SHOULD READING THE SCRIPT MODULES WHEN POSSIBLE"
echo "---> READING ALL SCRIPT MODULES WILL HELP YOU UNDERSTAND WHAT YOU ARE GOING TO DO IN THIS DEPLOY GUIDE"

while true; do
    echo -e "---> OK, PLEASE PRESS $GREEN ENTER $END_COLOR KEY TO DEPLOY NOW!"
    read -r
    break
done

# CHOOSE DEPLOY OLD OR NEW SOURCE
while true; do
    echo -e -n "PLEASE CHOOSE \"0\" TO DEPLOY WITH NEW SOURCE OR CHOOSE \"1\" TO DEPLOY WITH OLD SOURCE: "
    read input

    if [ $input = "0" ]; then
        all_module
        deploy_new_source
        break
    elif [ $input = "1" ]; then
        all_module
        deploy_old_source
        break
    else
        echo -e "$RED YOU DON'T CHOOSE \"0\" OR \"1\"$END_COLOR"
        continue
    fi
done

