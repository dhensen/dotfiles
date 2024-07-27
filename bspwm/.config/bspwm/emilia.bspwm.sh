#!/bin/sh
# put machine dependent stuff here


pkill -x wallpaper.sh
wallpaper.sh &

nm-applet &
blueman-applet &

pkill redshift
redshift-gtk -m randr -r -l 52.0685:4.5094 -t 5700:2700 &

pkill picom
picom --config /dev/null --backend glx --xrender-sync-fence --vsync -b

pkill stalonetray
stalonetray &

lxsession &

xautolock -corners "0000" -time 5 -locker lock.sh &!
setxkbmap -option caps:escape

# after factory resetting my monitors, things got twisted
# xrandr --output DP-2 --left-of HDMI-0
# bspc monitor DP-2 -d 1 2 3 4 5
# bspc monitor HDMI-0 -d 6 7 8 9 10
bspc monitor HDMI-0 -d 1 2 3 4 5 6 7 8 9 10

sudo fix_bluetooth
(sleep 5 && journalctl -S "$(date "+%F %T")" --no-pager -f -u earlyoom.service | grep --line-buffered "sending" | notifier "EarlyOOM" &)
