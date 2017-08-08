#!/bin/bash

# -----------------------------------------------------------------------------
# HOST_CUSTOM.SH
# -----------------------------------------------------------------------------
set -e
source $BASEDIR/$GIT_LOCAL_DIR/installer_sub_scripts/000_source

# -----------------------------------------------------------------------------
# INIT
# -----------------------------------------------------------------------------
[ "$RUN_HOST_CUSTOM" != true ] && exit
cd $BASEDIR/$GIT_LOCAL_DIR/installer_sub_scripts

echo
echo "---------------------- HOST CUSTOM ------------------------"

# -----------------------------------------------------------------------------
# PACKAGES
# -----------------------------------------------------------------------------
# upgrade
apt-get $APT_PROXY_OPTION -y dist-upgrade

# removed packages
apt-get -y purge nfs-common rpcbind nano
apt-get -y purge tasksel tasksel-data
apt-get -y purge aptitude
apt-get -y autoremove

# added packages
apt-get $APT_PROXY_OPTION -y install zsh tmux vim autojump
apt-get $APT_PROXY_OPTION -y install htop iotop bmon bwm-ng
apt-get $APT_PROXY_OPTION -y install iputils-ping fping dnsutils
apt-get $APT_PROXY_OPTION -y install zip lftp ack-grep
apt-get $APT_PROXY_OPTION -y install ipython3 bpython3

# -----------------------------------------------------------------------------
# SYSTEM CONFIGURATION
# -----------------------------------------------------------------------------
# keyboard default (Turkish)
cp ../host/etc/default/keyboard /etc/default/
systemctl restart keyboard-setup.service

# enable ssh
sed -i "s/^Port .*$/Port 30022/" /etc/ssh/sshd_config
systemctl enable ssh.service
systemctl stop ssh.service
systemctl start ssh.service

# pi password
echo pi:$PI_PASSWORD | chpasswd

# -----------------------------------------------------------------------------
# ROOT USER
# -----------------------------------------------------------------------------
chsh -s /bin/zsh root

# changed/added files
cp ../host/root/.vimrc /root/
cp ../host/root/.zshrc /root/

# -----------------------------------------------------------------------------
# PI USER
# -----------------------------------------------------------------------------
chsh -s /bin/zsh pi

# changed/added files
cp ../host/root/.vimrc /home/pi/
cp ../host/root/.zshrc /home/pi/
chown pi:pi /home/pi/.vimrc
chown pi:pi /home/pi/.zshrc

# Use the same SSH keys for user 'pi' if there is no customized authorized_keys
# file for this user.
if [ ! -f /home/pi/.ssh/authorized_keys -a -f /root/.ssh/authorized_keys]
then
    mkdir -p /home/pi/.ssh
    cp /root/.ssh/authorized_keys /home/pi/.ssh/
    chmod 700 /home/pi/.ssh
    chmod 600 /home/pi/.ssh/authorized_keys
    chown pi:pi /home/pi/.ssh -R
fi
