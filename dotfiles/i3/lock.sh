#!/bin/bash
MUTED=$(pacmd list-sinks | awk '/muted/ { print $2 }')
pactl set-sink-mute @DEFAULT_SINK@ 1
scrot /tmp/screenshot.png
convert /tmp/screenshot.png -blur 0x5 /tmp/screenshotblur.png
rm /tmp/screenshot.png
i3lock -n -i /tmp/screenshotblur.png && if [[ $MUTED != "yes" ]]; then pactl set-sink-mute @DEFAULT_SINK@ 0; fi
