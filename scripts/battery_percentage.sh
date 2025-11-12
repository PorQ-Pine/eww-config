#!/bin/bash

percentage=$(upower -i $(upower -e | grep 'battery') | grep "percentage" | awk '{print $2}' | sed 's/%//')
echo "$percentage"