#!/usr/bin/bash

scrot /tmp/lock.png
convert /tmp/lock.png -blur 0x4 /tmp/screen_locked.png
i3lock -i /tmp/screen_locked.png


