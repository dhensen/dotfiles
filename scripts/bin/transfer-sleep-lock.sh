#!/bin/bash

# Example locker script -- demonstrates how to use the --transfer-sleep-lock
# option with i3lock's forking mode to delay sleep until the screen is locked.

## CONFIGURATION ##############################################################

# Options to pass to i3lock
i3lock_options="-i /tmp/screen_locked.png"

# Run before starting the locker
pre_lock() {
    #mpc pause
    echo "pre_lock start"
    date +%s%N | cut -b1-13
    scrot /tmp/lock_screenshot.png
    # # scrot creates a sequence: lock.png lock_001.png lock_002.png...
    # # take latest lock
    latest=$(ls -t /tmp/lock_screenshot*.png | head -n1)
    convert $latest -blur 0x6 /tmp/screen_locked.png
    xset +dpms dpms 5 5 5
    echo "pre_lock end"
    date +%s%N | cut -b1-13
    return
}

# Run after the locker exits
post_lock() {
    echo "post_lock start"
    revert
    echo "post_lock end"
    return
}

revert() {
    xset dpms 0 0 0
}

trap revert HUP INT TERM

###############################################################################

pre_lock

# We set a trap to kill the locker if we get killed, then start the locker and
# wait for it to exit. The waiting is not that straightforward when the locker
# forks, so we use this polling only if we have a sleep lock to deal with.
if [[ -e /dev/fd/${XSS_SLEEP_LOCK_FD:--1} ]]; then
    kill_i3lock() {
        pkill -xu $EUID "$@" i3lock
    }

    trap kill_i3lock TERM INT

    # we have to make sure the locker does not inherit a copy of the lock fd
    i3lock $i3lock_options {XSS_SLEEP_LOCK_FD}<&-

    # now close our fd (only remaining copy) to indicate we're ready to sleep
    exec {XSS_SLEEP_LOCK_FD}<&-

    while kill_i3lock -0; do
        sleep 0.5
    done
else
    trap 'kill %%' TERM INT
    i3lock -n $i3lock_options &
    wait
fi

post_lock
