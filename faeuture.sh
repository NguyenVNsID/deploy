# FUNCTION TO GET NUMBER LINE, WHERE THE COMMAND ERROR OCCURS
cli_error() {
    local line="$1"
    local command="$2"
    echo "Error on line $line: $command"
    exit 1
}

trap 'cli_error $LINENO "$BASH_COMMAND"' ERR # TRAP ANY NON-ZERO EXIT CODES AND LOG THEM

# checksum

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

deploy_old_source() {
    echo "deploy old source"
}

deploy_new_source() {
    echo "deploy old source"
}