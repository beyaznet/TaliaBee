#!/bin/bash

# -----------------------------------------------------------------------------
# ZIGBEE.SH
# -----------------------------------------------------------------------------
set -e
source $BASEDIR/$GIT_LOCAL_DIR/installer_sub_scripts/000_source

# -----------------------------------------------------------------------------
# INIT
# -----------------------------------------------------------------------------
[ "$RUN_ZIGBEE" != true ] && exit
cd $BASEDIR/$GIT_LOCAL_DIR/component/zigbee

echo
echo "-------------------------- ZIGBEE --------------------------"

# -----------------------------------------------------------------------------
# PACKAGES
# -----------------------------------------------------------------------------
apt-get $APT_PROXY_OPTION -y install sqlite3
apt-get $APT_PROXY_OPTION -y install python3-cryptography

# Python modules via pip3
pip3 install pyserial sqlalchemy

# -----------------------------------------------------------------------------
# ZIGBEE
# -----------------------------------------------------------------------------
# doc
mkdir -p ~/doc
cp $BASEDIR/$GIT_REPO/doc/zigbee.md ~/doc/
cp profiles/profile_20A7.xml ~/doc/
cp profiles/profile_22A7.xml ~/doc/

# zigbee interface
rm -rf /home/pi/zigbee_interface
mkdir -p /home/pi/zigbee_interface
rsync -aChu home/pi/zigbee_interface/ /home/pi/zigbee_interface/
chown pi:pi /home/pi/zigbee_interface/ -R
chmod u+x /home/pi/zigbee_interface/run.py

# zigbee KEY and ME
sed -i "s/^ME\s*=.*$/ME = '$ZIGBEE_ME'/" /home/pi/zigbee_interface/config.py
sed -i "s/^KEY\s*=.*$/KEY = b'$ZIGBEE_KEY'/" /home/pi/zigbee_interface/config.py
sed -i "s/^API_BASE_URL\s*=.*$/API_BASE_URL = 'http:\/\/127.0.0.1\/api'/" \
    /home/pi/zigbee_interface/config.py

# systemd service
cp etc/systemd/system/zigbee_interface.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable zigbee_interface.service
systemctl start zigbee_interface.service
