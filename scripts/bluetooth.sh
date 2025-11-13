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

# This is a stupid workaround where dbus monitoring did not work (permissions) and bluetoothctl --monitor DIDN'T WORK AT ALL FOR NO REASON idk maybe it's shell breaks things
prev=""
while true; do
    curr=$(bluetoothctl show | rg "Powered|Discoverable|Pairable" | tr -d '[:space:]')
    if [[ "$curr" != "$prev" ]]; then
        get_bt
        prev="$curr"
    fi
    sleep 1
done
