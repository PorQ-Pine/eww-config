#!/bin/bash

state=$(upower -i $(upower -e | grep 'battery') 2>/dev/null | grep "state" | awk '{print $2}')

if [ -z "$state" ]; then
    state="Unknown"
fi

echo "$state"
