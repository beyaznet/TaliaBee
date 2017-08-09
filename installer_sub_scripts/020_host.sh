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

# data.json
[ -f /var/www/taliabee_web_interfaces/gui/app/storage/data.json ] && \
    cp /var/www/taliabee_web_interfaces/gui/app/storage/data.json $OLD_FILES/

# nginx
[ -f /etc/nginx/access_list_ip.conf ] && \
    cp /etc/nginx/access_list_ip.conf $OLD_FILES/
[ -f /etc/nginx/access_list_user.conf ] && \
    cp /etc/nginx/access_list_user.conf $OLD_FILES/

# -----------------------------------------------------------------------------
# PACKAGES
# -----------------------------------------------------------------------------
# remove apt-listchanges
apt-get -y purge apt-listchanges

# download upgradable packages
apt-get $APT_PROXY_OPTION -dy dist-upgrade
apt-get $APT_PROXY_OPTION -y upgrade

# added packages
apt-get $APT_PROXY_OPTION -y install wget curl rsync jq
apt-get $APT_PROXY_OPTION --install-recommends -y install python3-pip

# pip3 upgrade
pip3 install --upgrade pip setuptools
