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
# Python modules via pip3
pip3 install taliabeez

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

# systemd service
cp etc/systemd/system/zigbee_interface.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable zigbee_interface.service
systemctl start zigbee_interface.service
