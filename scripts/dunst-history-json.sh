#!/bin/bash
paused=$(dunstctl get-pause-level | grep -q 1 && echo true || echo false)

dunstctl history | jq -c --argjson paused "$paused" '
{
  paused: $paused,
  notifications: [
    .data[0][] |
    {
      id: .id.data,
      summary: .summary.data,
      body: .body.data,
      icon: .icon_path.data,
      appname: .appname.data,
    }
  ]
}
'

exit 0