#!/bin/bash

# -----------------------------------------------------------------------------
# COMPLETED.SH
# -----------------------------------------------------------------------------
set -e
source $BASEDIR/$GIT_LOCAL_DIR/installer_sub_scripts/000_source
[ "$DONT_RUN_COMPLETED" = true ] && exit

echo
echo '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
echo '@                                                         @'
echo '@                 INSTALLATION COMPLETED                  @'
echo '@                                                         @'
echo '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
echo
