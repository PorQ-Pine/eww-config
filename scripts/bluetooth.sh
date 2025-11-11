#!/bin/bash

get_bt() {
  power=$(bluetoothctl show | rg "Powered:" | awk '{print $2}')
  if [ "$power" != "yes" ]; then
    echo '{"on":false,"name":"","signal":""}'
    return
  fi

  mac=$(bluetoothctl devices | awk '{print $2}' | while read -r m; do
    bluetoothctl info "$m" | rg -q "Connected: yes" && echo "$m" && break
  done)

  if [ -z "$mac" ]; then
    echo '{"on":true,"name":"","signal":""}'
    return
  fi

  name=$(bluetoothctl info "$mac" | rg "Name" | sed 's/^[[:space:]]*Name: //; s/"/\\"/g')
  rssi=$(bluetoothctl info "$mac" | rg "RSSI" | awk '{print $2}')
  echo '{"on":true,"name":"'"$name"'","signal":"'"$rssi"'"}'
}

get_bt

dbus-monitor --system \
  "type='signal',interface='org.freedesktop.DBus.Properties',member='PropertiesChanged',sender='org.bluez'" \
  | rg --line-buffered "RSSI|Connected|Powered" \
  | while read -r _; do
      get_bt
    done
