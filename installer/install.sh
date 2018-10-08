#!/bin/bash

# -----------------------------------------------------------------------------
# INSTALL.SH
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# DEFAULTS
# -----------------------------------------------------------------------------
export CONFIG_FILE="taliabee.conf"
export FREE_SPACE_NEEDED="1000000"

export START_TIME=`date +%s`
export DATE=`date +"%Y%m%d%H%M%S"`
export GIT_REPO="https://github.com/beyaznet/TaliaBee.git"
export GIT_BRANCH="master"
export GIT_LOCAL_DIR="TaliaBee"
export RELEASE="Raspbian GNU/Linux"
export BASEDIR=`pwd`

export PI_PASSWORD="raspberry"

# -----------------------------------------------------------------------------
# CUSTOMIZATION
# -----------------------------------------------------------------------------
# Please set the related environment variables in taliabee.conf file to prevent
# to run some scripts, to prevent to check some criteria and to set some values
# during the installation.
#
# Examples:
#		export DONT_RUN_HOST_CUSTOM=true
#		export DONT_RUN_BCM2835=true
#		export PI_PASSWORD="raspberry"
# -----------------------------------------------------------------------------
[ -e "$BASEDIR/$CONFIG_FILE" ] && source "$BASEDIR/$CONFIG_FILE"

# -----------------------------------------------------------------------------
# CHECKING THE HOST
# -----------------------------------------------------------------------------
# If the current user is not 'root', cancel the installation.
if [ "root" != "`whoami`" ]
then
	echo
	echo "ERROR: unauthorized user"
	echo "Please, run the installation script as 'root' or use sudo"
	echo "    sudo bash install.sh"
	exit 1
fi

# If the OS release is unsupported, cancel the installation.
if [ "$DONT_CHECK_OS_RELEASE" != true \
     -a -z "$(grep "$RELEASE" /etc/os-release)" ]
then
	echo
	echo "ERROR: unsupported OS release"
	echo "Please, use '$RELEASE' on host machine"
	exit 1
fi

# If there is not enough disk free space, cancel the installation.
FREE=$(df | egrep "/$" | awk '{ print $4; }')
if [ "$DONT_CHECK_FREE_SPACE" != true \
     -a "$FREE" -lt "$FREE_SPACE_NEEDED" ]
then
	echo
	echo "ERROR: there is not enough disk free space"
	echo
	df -h
	exit 1
fi

set -e

# -----------------------------------------------------------------------------
# CLONING THE GIT REPO
# -----------------------------------------------------------------------------
if [ "$DONT_CLONE_GIT_REPO" != true ]
then
	apt-get $APT_PROXY_OPTION update
	apt-get $APT_PROXY_OPTION install -y git

	rm -rf $GIT_LOCAL_DIR
	git clone --depth=1 -b $GIT_BRANCH $GIT_REPO $GIT_LOCAL_DIR
fi

# -----------------------------------------------------------------------------
# RUNNING THE SUB INSTALLATION SCRIPTS
# -----------------------------------------------------------------------------
cd $BASEDIR/$GIT_LOCAL_DIR/installer_sub_scripts

for sub in `ls *.sh`
do
	bash $sub
done

# -----------------------------------------------------------------------------
# INSTALLATION DURATION
# -----------------------------------------------------------------------------
END_TIME=`date +%s`
DURATION=`date -u -d "0 $END_TIME seconds - $START_TIME seconds" +"%H:%M:%S"`

echo Installation Duration: $DURATION
