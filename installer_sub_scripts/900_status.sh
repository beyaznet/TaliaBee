#!/bin/bash

# -----------------------------------------------------------------------------
# STATUS.SH
# -----------------------------------------------------------------------------
set -e

# -----------------------------------------------------------------------------
# INIT
# -----------------------------------------------------------------------------
[ "$DONT_RUN_STATUS" = true ] && exit

echo
echo "-------------------------- STATUS --------------------------"

# -----------------------------------------------------------------------------
# SHOW STATUS
# -----------------------------------------------------------------------------
# Zigbee
if [ "$RUN_ZIGBEE" = true ]
then
	echo 'ZIGBEE INTERFACE'
	echo "------------------------------------------------"
	echo -n "Zigbee Key (KEY)     : "
	echo $ZIGBEE_KEY
	echo
fi
