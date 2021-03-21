#!/bin/bash

if [[ $# -lt 1 ]]
then
    exit 1
fi

function playerctlReady {
    return $([[ $(playerctl -l 2>&1) != "No players were found" ]])
}

function play {
    if playerctlReady
    then
        playerctl play
    else
        mpc play > /dev/null
    fi
}

function pause {
    if playerctlReady
    then
        playerctl pause
    else
        mpc pause > /dev/null
    fi
}

function toggle {
    if playerctlReady
    then
        playerctl play-pause
    else
        mpc toggle > /dev/null
    fi
}

function previous {
    if playerctlReady
    then
        playerctl previous
    else
        mpc prev > /dev/null
    fi
}

function next {
    if playerctlReady
    then
        playerctl next
    else
        mpc next > /dev/null
    fi
}

function stop {
    if playerctlReady
    then
        playerctl stop
    else
        mpc stop
    fi
}

case $1 in
    "play")
        play
        ;;
    "pause")
        pause
        ;;
    "toggle" | "play-pause")
        toggle
        ;;
    "previous" | "prev")
        previous
        ;;
    "next")
        next
        ;;
    "stop")
        stop
        ;;
esac
