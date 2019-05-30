#!/bin/sh
# put machine dependent stuff here

#xfsettingsd --disable-wm-check &
#xfce4-power-manager --disable-wm-check &
#xfce4-panel --disable-wm-check &
plank &

pkill -x wallpaper.sh
wallpaper.sh &

nm-applet &


#redshift -m randr -r -l 52.0685:4.5094 -t 5700:2700 &
redshift-gtk -m randr -r -l 52.0685:4.5094 -t 5700:2700 &
