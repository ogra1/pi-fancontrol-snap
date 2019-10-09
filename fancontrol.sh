#! /bin/sh

#
# init gpio for pin 08:
# pi4-devel:bcm-gpio-14
#
# GPIO=14
#
# echo ${GPIO} >/sys/class/gpio/export
# echo out >/sys/class/gpio/gpio${GPIO}/direction
#

set -e

INTERVAL="120"
THRESHOLD="50"
GPIO="14"

while [ ! -f /sys/class/gpio/gpio${GPIO}/value ]
do
  sleep 1
  echo "fancontrol: sleeping while waiting for /sys/class/gpio/gpio${GPIO}/value"
done

if [ "(cat /sys/class/gpio/gpio${GPIO}/direction)" != "out" ]; then
  echo out >/sys/class/gpio/gpio${GPIO}/direction
fi

get_temp() {
  THERMAL="$(($(cat /sys/devices/virtual/thermal/thermal_zone0/temp)/1000))"
  echo "$THERMAL"
}

get_status(){
  STATUS="$(cat /sys/class/gpio/gpio${GPIO}/value)"
  echo "$STATUS"
}

echo "starting at $(date +%d.%m.%Y-%H:%M:%S)"

if [ "$(get_status)" = "1" ]; then
  echo "startup: fan is on at $(get_temp) °C"
else
  echo "startup: fan is off at $(get_temp) °C"
fi

while true; do
  if [ "$(get_temp)" -gt "$THRESHOLD" ]; then
    if [ "$(get_status)" = "0" ]; then
      echo "1" >/sys/class/gpio/gpio${GPIO}/value
      echo "$(date +%d.%m.%Y-%H:%M:%S): fan on at $(get_temp) °C"
    fi
  else 
    if [ "$(get_status)" = "1" ]; then
      echo "0" >/sys/class/gpio/gpio${GPIO}/value
      echo "$(date +%d.%m.%Y-%H:%M:%S): fan off at $(get_temp) °C"
    fi
  fi
  sleep ${INTERVAL}
done

