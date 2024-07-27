#!/usr/bin/bash
# this requires yay -S i3lock-blur

set -x

# rm -f /tmp/screen_locked.png /tmp/lock.png
scrot -o /tmp/lock.png

# 0x04 is the minimum amount of blur, below that text becomes readable/guessable
# convert /tmp/lock.png -blur 0x05 /tmp/screen_locked.png
blur /tmp/lock.png /tmp/screen_locked.png
i3lock -i /tmp/screen_locked.png --nofork
