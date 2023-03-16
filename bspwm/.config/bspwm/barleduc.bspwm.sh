#!/bin/sh
# put machine dependent stuff here

stalonetray &
snixembed --fork

pkill -x wallpaper.sh
wallpaper.sh &

#nm-applet &
picom -b --vsync --config /dev/null

#redshift -m randr -r -l 52.0685:4.5094 -t 5700:2700 &
redshift-gtk -m randr -r -l 52.0685:4.5094 -t 5700:2700 &

iwgtk -i &
polkit-dumb-agent &

#xautolock -locker lock.sh -time 10 -notify 20 -notifier lock_notify &
init_lock &

setxkbmap -option caps:escape
