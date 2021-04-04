#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar, using default config location ~/.config/polybar/config
if xrandr | grep -q "HDMI1 connected primary 1920x1080"; then
    polybar bot &
    polybar top &
else
    polybar botvertical &
    polybar topvertical &
fi

echo "Polybar launched..."