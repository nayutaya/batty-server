#! /bin/sh

DEVICE_TOKEN=0000000000
BATTERY_LEVEL=`pmset -g ps | egrep -o "[0-9]+%" | sed "s/%//"`
TIME=`date "+%Y%m%d%H%M%S"`

BASE_URL="http://localhost:3000"
UPDATE_URL="${BASE_URL}/device/${DEVICE_TOKEN}/energies/update/${BATTERY_LEVEL}/${TIME}"

