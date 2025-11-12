#!/bin/bash

DEVICE="backlight_cool"
PATH_BASE="/sys/class/backlight/${DEVICE}"

print_brightness() {
    cat "${PATH_BASE}/actual_brightness"
}

print_brightness

udevadm monitor --subsystem-match=backlight --property |
while read -r line; do
    if [[ "$line" == "ACTION=change" ]]; then
        print_brightness
    fi
done
