#!/bin/sh
# put machine dependent stuff here

#xfsettingsd --disable-wm-check &
#xfce4-panel --disable-wm-check &
#/usr/lib/xfce4/notifyd/xfce4-notifyd &


#plank &

pkill -x wallpaper.sh
wallpaper.sh &

nm-applet &
#redshift-gtk -m randr -r -l 52.0685:4.5094 -t 5700:2700 &
