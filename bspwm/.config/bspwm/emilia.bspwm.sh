#!/bin/sh
# put machine dependent stuff here


pkill -x wallpaper.sh
wallpaper.sh &

nm-applet &
blueman-applet &
redshift-gtk -m randr -r -l 52.0685:4.5094 -t 5700:2700 &

xautolock -corners "0-00" -time 5 -locker lock.sh &!

