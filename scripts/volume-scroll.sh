#!/usr/bin/env bash

LOCKFILE="/tmp/volume_scroll.lock"
DEBOUNCE_MS=30
LAST_FILE="/tmp/volume_scroll.last"

exec 200>"$LOCKFILE"
flock -n 200 || exit

NOW_MS=$(date +%s%3N)
LAST_MS=0
[ -f "$LAST_FILE" ] && LAST_MS=$(cat "$LAST_FILE")

if (( NOW_MS - LAST_MS < DEBOUNCE_MS )); then
    exit
fi

echo "$NOW_MS" > "$LAST_FILE"

DIRECTION="$1"

# Unmute before changing volume
pactl set-sink-mute @DEFAULT_SINK@ 0

if [ "$DIRECTION" = "up" ]; then
    pactl set-sink-volume @DEFAULT_SINK@ +1%
else
    pactl set-sink-volume @DEFAULT_SINK@ -1%
fi
