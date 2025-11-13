#!/bin/bash
lockfile="/tmp/eww_update_history.lock"
timestamp_file="/tmp/eww_update_history.timestamp"

exec 200>"$lockfile"
flock -n 200 || exit 1

last=$(cat "$timestamp_file" 2>/dev/null || echo 0)
now=$(date +%s)

if (( now - last >= 5 )); then
    eww update notifications_data="$(~/.config/eww/scripts/dunst-history-json.sh)"
    echo "$now" > "$timestamp_file"
fi
