#!/usr/bin/env bash

OPTS=$(getopt -l "pixelize,xkcd::,text::,profile::" -o "px::t::" -- "$@")
eval set -- "$OPTS"
while true; do
    case "$1" in
        --pixelize|-p)
            PIXELIZE=true
            ;;
        --xkcd|-x)
            shift
            POSITIONS=${1//,/ }
            ;;
        --text|-t)
            shift
            TEXT=$1
            ;;
        --profile)
            shift
            PROFILE=$1
            ;;
        --)
            shift
            break
            ;;
    esac
    shift
done

case $PROFILE in
    mobile)
    POSITIONS="+0+0"
    ;;
    home|office)
    POSITIONS="-960+0 +960+0"
    ;;
esac

dunstctl set-paused true

scrot /tmp/screenshot.png
if [[ $PIXELIZE = true ]]; then
    convert /tmp/screenshot.png -scale 5% -scale 2000% /tmp/screenshotblur.png
else
    convert /tmp/screenshot.png -blur 0x30 /tmp/screenshotblur.png
fi
rm /tmp/screenshot.png

if [[ -n $TEXT ]]; then
    convert /tmp/screenshotblur.png -pointsize 300 -fill white -stroke black -strokewidth 5 -gravity center -annotate 0 "$TEXT" /tmp/screenshotblur.png
fi

function random_xkcd() {
    MAX=$1
    NUM=$(shuf -i 1-$MAX -n 1)
    mkdir -p "$HOME/.cache/xkcd"
    FILE="$HOME/.cache/xkcd/$NUM.png"
    if [[ ! -f "$FILE" ]]; then
        URL=$(curl -s "https://xkcd.com/$NUM/info.0.json" | jq -r .img)
        curl $URL -o $FILE
    fi
    echo $FILE
}

if [[ -n $POSITIONS ]]; then
    CURRENT=$(curl -s 'https://xkcd.com/info.0.json' | jq .num)
    for p in $POSITIONS; do
        composite -gravity center -geometry $p $(random_xkcd $CURRENT) /tmp/screenshotblur.png /tmp/screenshotblur.png
    done
fi

i3lock -n -i /tmp/screenshotblur.png && dunstctl set-paused false && rm /tmp/screenshotblur.png
