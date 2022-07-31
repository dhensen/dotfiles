#!/bin/sh
# put machine dependent stuff here

pkill -x wallpaper.sh
wallpaper.sh &

#nm-applet &
#picom -b
#picom --experimental-backends --config /etc/xdg/picom.conf
picom -b --backend xr_glx_hybrid --vsync --config /dev/null
stalonetray &


#redshift -m randr -r -l 52.0685:4.5094 -t 5700:2700 &
redshift-gtk -m randr -r -l 52.0685:4.5094 -t 5700:2700 &

xautolock -locker lock.sh -time 10 -notify 20 -notifier lock_notify &

