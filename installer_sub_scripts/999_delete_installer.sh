#!/bin/bash

# -----------------------------------------------------------------------------
# DELETE_INSTALLER.SH
# -----------------------------------------------------------------------------
set -e
source $BASEDIR/$GIT_LOCAL_DIR/installer_sub_scripts/000_source
[ "$DONT_RUN_DELETE_INSTALLER" = true ] && exit

# remove the installer
cd $BASEDIR
rm -f install.sh
rm -rf $GIT_LOCAL_DIR
