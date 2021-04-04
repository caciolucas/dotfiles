#!/bin/bash

if xrandr | grep -q "HDMI1 connected primary 1920x1080"; then
    feh --no-fehbg --bg-fill '/home/caciolucas/.wall.png'
    betterlockscreen --update '/home/caciolucas/.wall.png'
else
    betterlockscreen --update '/home/caciolucas/.wallvertical.png'
    feh --no-fehbg --bg-fill '/home/caciolucas/.wallvertical.png'
fi