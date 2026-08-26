#!/usr/bin/bash
# this requires yay -S i3lock-blur

set -x

# rm -f /tmp/screen_locked.png /tmp/lock.png
scrot -o /tmp/lock.png

# 0x04 is the minimum amount of blur, below that text becomes readable/guessable

# if blur command is available, use it
if command -v blur >/dev/null 2>&1; then
    blur /tmp/lock.png /tmp/screen_locked.png
else
    convert /tmp/lock.png -blur 0x05 /tmp/screen_locked.png
fi

i3lock -i /tmp/screen_locked.png --nofork
