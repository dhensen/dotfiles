#!/usr/bin/bash

# usage: xautolock -locker lock.sh -time 1 -notify 10 -notifier lock_notify &!

# revert() {
#     xset dpms 0 0 0
# }

# trap revert HUP INT TERM

# scrot /tmp/lock_screenshot.png
# # scrot creates a sequence: lock.png lock_001.png lock_002.png...
# # take latest lock
# latest=$(ls -t /tmp/lock_screenshot*.png | head -n1)
# convert $latest -blur 0x4 /tmp/screen_locked.png

# xset +dpms dpms 5 5 5

# i3lock -n -i /tmp/screen_locked.png

# revert

blank=33000000
tc=b0b0b0ff
rc=5E81ACff
ic=121315a4
wc=81A1C1ff

khl=81A1C1ff
bshl=81A1C1ff


blur=6
width=7
delta=55
radius=125
datesize=15
timesize=30

i3lock \
    --nofork \
    --blur 2 \
    --indicator \
    --clock \
    --timesize=$timesize \
    --datesize=$datesize \
    --timestr="%I:%M:%S" \
    --datestr="%B %d, %Y" \
    --linecolor=$blank \
    --insidecolor=$ic --ringcolor=$rc \
    --datecolor=$tc --timecolor=$tc \
    --separatorcolor=$rc --keyhlcolor=${khl#\#} \
    --bshlcolor=${bshl#\#} \
    --verifcolor=$tc --wrongcolor=$tc \
    --ringvercolor=${rvc:-$rc} --ringwrongcolor=$wc \
    --insidevercolor=$ic --insidewrongcolor=$ic \
