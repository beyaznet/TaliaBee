#!/bin/bash

# -----------------------------------------------------------------------------
# HOST.SH
# -----------------------------------------------------------------------------
set -e
source $BASEDIR/$GIT_LOCAL_DIR/installer_sub_scripts/000_source

# -----------------------------------------------------------------------------
# INIT
# -----------------------------------------------------------------------------
[ "$DONT_RUN_HOST" = true ] && exit
cd $BASEDIR/$GIT_LOCAL_DIR/installer_sub_scripts

echo
echo "--------------------------- HOST ---------------------------"

# -----------------------------------------------------------------------------
# BACKUP & STATUS
# -----------------------------------------------------------------------------
OLD_FILES="/root/talia/old_files_$DATE"
mkdir -p $OLD_FILES

# network status
echo "# ----- ip addr -----" >> $OLD_FILES/network.status
ip addr >> $OLD_FILES/network.status
echo >> $OLD_FILES/network.status
echo "# ----- ip route -----" >> $OLD_FILES/network.status
ip route >> $OLD_FILES/network.status

# process status
echo "# ----- ps auxfw -----" >> $OLD_FILES/ps.status
ps auxfw >> $OLD_FILES/ps.status

# deb status
echo "# ----- dpkg -l -----" >> $OLD_FILES/dpkg.status
dpkg -l >> $OLD_FILES/dpkg.status

# -----------------------------------------------------------------------------
# PACKAGES
# -----------------------------------------------------------------------------
# remove apt-listchanges
apt-get -y purge apt-listchanges

# download upgradable packages
apt-get $APT_PROXY_OPTION -dy dist-upgrade
apt-get $APT_PROXY_OPTION -y upgrade

# added packages
apt-get $APT_PROXY_OPTION -y install wget curl rsync
apt-get $APT_PROXY_OPTION --install-recommends -y install python3-pip

# pip3 upgrade
pip3 install --upgrade pip setuptools
