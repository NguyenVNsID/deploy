PASSWORD='echo "$password" |'
echo -n "Enter your password: "
stty -echo
read password
stty echo
echo    # this is just for a newline after entering the password

# Use sudo with -S option to read the password from standard input
echo "---> RUNNING COMMAND$GREEN sudo apt update -y$END_COLOR"
eval "$PASSWORD sudo -S apt update -y >> /dev/null"

echo "---> RUNNING COMMAND$GREEN sudo apt upgrade -y$END_COLOR"
eval "$PASSWORD sudo -S apt upgrade -y >> /dev/null"