#!/bin/bash

SQUEEKBOARD_PID=$(pgrep squeekboard)
SHOWN_FLAG="/tmp/squeekboard_shown"

if [ -z "$SQUEEKBOARD_PID" ]; then
    # squeekboard is not running, start it and set shown flag
    squeekboard-restyled &
    touch "$SHOWN_FLAG"
else
    # squeekboard is running
    if [ -f "$SHOWN_FLAG" ]; then
        # It's shown, so hide it
        busctl call --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 SetVisible b false
        rm "$SHOWN_FLAG"
    else
        # It's not shown, so show it
        busctl call --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 SetVisible b true
        touch "$SHOWN_FLAG"
    fi
fi
