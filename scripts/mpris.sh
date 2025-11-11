#!/bin/bash
base_dir="$HOME/.config/eww/"

playerctl metadata -F -f \
'{"name":"{{playerName}}","title":"{{title}}","artist":"{{artist}}","artUrl":"{{mpris:artUrl}}","status":"{{status}}","length":"{{mpris:length}}"}' |
while read -r raw; do
    name=$(jq -r '.name' <<< "$raw")
    title=$(jq -r '.title' <<< "$raw")
    artist=$(jq -r '.artist' <<< "$raw")
    artUrl=$(jq -r '.artUrl' <<< "$raw")
    status=$(jq -r '.status' <<< "$raw")
    length=$(jq -r '.length' <<< "$raw")

    if [[ -n "$length" && "$length" != "null" ]]; then
        length=$(( (length + 500000) / 1000000 ))
    else
        length=""
    fi

    artUrl="${artUrl#file://}"

    lengthStr=$(playerctl metadata -f "{{duration(mpris:length)}}")

    JSON_STRING=$( jq -n \
        --arg name "$name" \
        --arg title "$title" \
        --arg artist "$artist" \
        --arg artUrl "$artUrl" \
        --arg status "$status" \
        --arg length "$length" \
        --arg lengthStr "$lengthStr" \
        '{name: $name, title: $title, artist: $artist, artUrl: $artUrl, status: $status, length: $length, lengthStr: $lengthStr}' )

    echo $JSON_STRING
done
