#!/bin/bash

print_brightness() {
    cur=$(brightnessctl g)
    max=$(brightnessctl m)
    echo $((cur * 100 / max))
}

print_brightness

udevadm monitor --subsystem-match=backlight --property |
while read -r line; do
    if [[ "$line" == "ACTION=change" ]]; then
        print_brightness
    fi
done
