#!/bin/sh
# put machine dependent stuff here


pkill -x wallpaper.sh
wallpaper.sh &

pkill -x nm-applet
nm-applet &

pkill blueman-applet
blueman-applet &


#redshift -m randr -r -l 52.0685:4.5094 -t 5700:2700 &
pkill -x redshift-gtk
redshift-gtk -m randr -r -l 52.0685:4.5094 -t 5700:2700 &

pkill -x picom
picom -b --no-fading-openclose
#picom -b --experimental-backends --vsync --config /dev/null

libinput-gestures-setup start &

# pkill -x stalonetray
# stalonetray &

# pkill plank
# plank &!

# 1password tray icon support
pkill -x snixembed
snixembed &

# so that 1password can login using linux auth instead of typing masterkey all the time
pkill -x polkit-dumb-agent
polkit-dumb-agent &

init_lock &
#xautolock -locker lock.sh -time 10 -notify 20 -notifier lock_notify &!

setxkbmap -layout us,us -variant ,alt-intl -option grp:shifts_toggle
setxkbmap -option caps:escape

pkill alttab
alttab -w 1 -d 1 -fg "#aec8db" -bw 10 -t 128x150 -i 127x64 -font "xft:Iosevka Term-12" &!


