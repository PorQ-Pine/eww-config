#!/bin/bash

# Check if Dunst is paused
paused=$(dunstctl get-pause-level | grep -q 1 && echo true || echo false)

# Get notifications JSON from dunstctl
history=$(dunstctl history)

# Determine if there are any notifications
empty=$(echo "$history" | jq '[.data[0][]] | length == 0')

# Build final JSON output
echo "$history" | jq -c --argjson paused "$paused" --argjson empty "$empty" '
{
  paused: $paused,
  empty: $empty,
  notifications: [
    .data[0][] |
    {
      id: .id.data,
      summary: .summary.data,
      body: .body.data,
      icon: .icon_path.data,
      appname: .appname.data
    }
  ]
}
'

exit 0
