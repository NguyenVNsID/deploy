



# MAKE UBUNTU FASTER
# remove language-related ign from apt update
echo 'Acquire::Languages "none";' >> /etc/apt/apt.conf.d/00aptitude