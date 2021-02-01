#!/usr/bin/bash

rm -f /tmp/screen_locked.png /tmp/lock.png
scrot /tmp/lock.png

convert /tmp/lock.png -blur 0x12 /tmp/screen_locked.png
i3lock -i /tmp/screen_locked.png -l --nofork
