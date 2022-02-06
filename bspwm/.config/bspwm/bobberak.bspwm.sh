#!/bin/sh
# put machine dependent stuff here


pkill -x wallpaper.sh
wallpaper.sh &

nm-applet &


#redshift -m randr -r -l 52.0685:4.5094 -t 5700:2700 &
redshift-gtk -m randr -r -l 52.0685:4.5094 -t 5700:2700 &
picom -b
stalonetray &

xautolock -locker lock.sh -time 10 -notify 20 -notifier lock_notify &!
