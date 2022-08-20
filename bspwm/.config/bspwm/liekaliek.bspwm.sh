#!/bin/sh
# put machine dependent stuff here

pkill -x wallpaper.sh
wallpaper.sh &

nm-applet &
picom -b
stalonetray &

#redshift -m randr -r -l 52.0685:4.5094 -t 5700:2700 &
redshift-gtk -m randr -r -l 52.0685:4.5094 -t 5700:2700 &
init_lock &

