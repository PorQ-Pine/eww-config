#!/bin/bash

percentage=$(upower -i $(upower -e | grep 'battery') 2>/dev/null | grep "percentage" | awk '{print $2}' | sed 's/%//')

if [ -z "$percentage" ]; then
    percentage=0
fi

echo "$percentage"