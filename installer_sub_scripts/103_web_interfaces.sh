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
apt-get $APT_PROXY_OPTION -y install apache2-utils
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

npm install bootstrap-toggle@2
mkdir -p /var/www/taliabee_web_interfaces/gui/app/static/bootstrap-toggle/{css,js}
cp -arp node_modules/bootstrap-toggle/css/* \
    /var/www/taliabee_web_interfaces/gui/app/static/bootstrap-toggle/css/
cp -arp node_modules/bootstrap-toggle/js/* \
    /var/www/taliabee_web_interfaces/gui/app/static/bootstrap-toggle/js/

npm install jquery@3
mkdir -p /var/www/taliabee_web_interfaces/gui/app/static/jquery
cp -arp node_modules/jquery/dist/* \
    /var/www/taliabee_web_interfaces/gui/app/static/jquery/

npm install vue
mkdir -p /var/www/taliabee_web_interfaces/gui/app/static/vue
cp -arp node_modules/vue/dist/* \
    /var/www/taliabee_web_interfaces/gui/app/static/vue/

npm install lodash
mkdir -p /var/www/taliabee_web_interfaces/gui/app/static/lodash
cp -arp node_modules/lodash/* \
    /var/www/taliabee_web_interfaces/gui/app/static/lodash/

npm install font-awesome@4
mkdir -p /var/www/taliabee_web_interfaces/gui/app/static/font-awesome/{css,fonts}
cp -arp node_modules/bootstrap-toggle/css/* \
    /var/www/taliabee_web_interfaces/gui/app/static/bootstrap-toggle/css/
cp -arp node_modules/bootstrap-toggle/fonts/* \
    /var/www/taliabee_web_interfaces/gui/app/static/bootstrap-toggle/fonts/

chown pi:pi /var/www/taliabee_web_interfaces/gui -R

# TaliaBee testers
mkdir -p /home/pi/taliabee
cp home/pi/taliabee/taliabee_tester.sh /home/pi/taliabee/
cp home/pi/taliabee/taliabee_tester.py /home/pi/taliabee/
chown pi:pi /home/pi/taliabee -R

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
cp etc/nginx/access_list_ip.conf /etc/nginx/
cp etc/nginx/access_list_user.conf /etc/nginx/
cp etc/nginx/sites-available/talia.conf /etc/nginx/sites-available/
rm -f /etc/nginx/sites-enabled/default
rm -f /etc/nginx/sites-enabled/talia.conf
ln -s /etc/nginx/sites-available/talia.conf /etc/nginx/sites-enabled/
systemctl stop nginx.service
systemctl start nginx.service
