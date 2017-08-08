#!/bin/bash

# -----------------------------------------------------------------------------
# WEB_INTERFACES.SH
# -----------------------------------------------------------------------------
set -e
source $BASEDIR/$GIT_LOCAL_DIR/installer_sub_scripts/000_source

# -----------------------------------------------------------------------------
# INIT
# -----------------------------------------------------------------------------
[ "$DONT_RUN_WEB_INTERFACES" = true ] && exit
cd $BASEDIR/$GIT_LOCAL_DIR/component/web_interfaces

echo
echo "---------------------- WEB INTERFACES ----------------------"

# -----------------------------------------------------------------------------
# PACKAGES
# -----------------------------------------------------------------------------
apt-get $APT_PROXY_OPTION -y install nginx-extras ssl-cert
apt-get $APT_PROXY_OPTION -y install uwsgi uwsgi-plugin-python3
apt-get $APT_PROXY_OPTION -y install npm

# Python modules via pip3
pip3 install flask

# -----------------------------------------------------------------------------
# WEB INTERFACES
# -----------------------------------------------------------------------------
rm -rf /var/www/taliabee_web_interfaces

# api
mkdir -p /var/www/taliabee_web_interfaces/api
rsync -aChu var/www/taliabee_web_interfaces/api/ \
    /var/www/taliabee_web_interfaces/api/

# gui
mkdir -p /var/www/taliabee_web_interfaces/gui
rsync -aChu var/www/taliabee_web_interfaces/gui/ \
    /var/www/taliabee_web_interfaces/gui/

npm install bootstrap@3
mkdir -p /var/www/taliabee_web_interfaces/gui/app/static/bootstrap
cp -arp node_modules/bootstrap/dist/* \
    /var/www/taliabee_web_interfaces/gui/app/static/bootstrap/

npm install jquery@3
mkdir -p /var/www/taliabee_web_interfaces/gui/app/static/jquery
cp -arp node_modules/jquery/dist/* \
    /var/www/taliabee_web_interfaces/gui/app/static/jquery/

npm install vue
mkdir -p /var/www/taliabee_web_interfaces/gui/app/static/vue
cp -arp node_modules/vue/dist/* \
    /var/www/taliabee_web_interfaces/gui/app/static/vue/

chown pi:pi /var/www/taliabee_web_interfaces/gui -R

# TaliaBee testers
mkdir -p /home/pi/test
cp home/pi/test/taliabee_tester.sh /home/pi/test/
cp home/pi/test/taliabee_tester.py /home/pi/test/
chown pi:pi /home/pi/test -R

# uwsgi
cp etc/uwsgi/apps-available/api.ini /etc/uwsgi/apps-available/
cp etc/uwsgi/apps-available/gui.ini /etc/uwsgi/apps-available/
rm -f /etc/uwsgi/apps-enabled/api.ini
rm -f /etc/uwsgi/apps-enabled/gui.ini
ln -s ../apps-available/api.ini /etc/uwsgi/apps-enabled/
ln -s ../apps-available/gui.ini /etc/uwsgi/apps-enabled/
systemctl stop uwsgi.service
systemctl start uwsgi.service

# nginx
cp etc/nginx/sites-available/talia.conf /etc/nginx/sites-available/
rm -f /etc/nginx/sites-enabled/default
rm -f /etc/nginx/sites-enabled/talia.conf
ln -s /etc/nginx/sites-available/talia.conf /etc/nginx/sites-enabled/
systemctl stop nginx.service
systemctl start nginx.service
