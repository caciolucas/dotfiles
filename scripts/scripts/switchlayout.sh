#!/bin/sh


if xrandr | grep -q "HDMI1 connected primary 1920x1080"; then
    source ~/scripts/verticallayout.sh
else
    source ~/scripts/layout.sh
fi

#source ~/scripts/setwallpaper.sh