#!/usr/bin/bash

# usage: xautolock -locker lock.sh -time 1 -notify 10 -notifier lock_notify &!

revert() {
    xset dpms 0 0 0
}

trap revert HUP INT TERM

scrot /tmp/lock_screenshot.png
# # scrot creates a sequence: lock.png lock_001.png lock_002.png...
# # take latest lock
latest=$(ls -t /tmp/lock_screenshot*.png | head -n1)
convert $latest -blur 0x6 /tmp/screen_locked.png

xset +dpms dpms 5 5 5

i3lock -n -i /tmp/screen_locked.png

revert
