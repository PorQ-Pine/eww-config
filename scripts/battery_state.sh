#!/bin/bash

state=$(upower -i $(upower -e | grep 'battery') | grep "state" | awk '{print $2}')
echo "$state"
