#!/bin/bash
set -x

# Example locker script -- demonstrates how to use the --transfer-sleep-lock
# option with i3lock's forking mode to delay sleep until the screen is locked.

## CONFIGURATION ##############################################################

# Options to pass to i3lock
screenshot_path="/tmp/i3lock_screenshot.png"

# Run before starting the locker
pre_lock() {
	#mpc pause
	echo "pre_lock start"
	#date +%s%N | cut -b1-13
	scrot -o $screenshot_path
	convert  $screenshot_path -blur 0x9 $screenshot_path
	xset +dpms dpms 5 5 5
	echo "pre_lock end"
	#date +%s%N | cut -b1-13
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
    # xset s 240 60
}

# Check if the mouse is in the top right corner
is_mouse_in_corner() {
    local mouse_x=$(xdotool getmouselocation --shell | grep "X=" | awk -F "=" '{print $2}')
    local mouse_y=$(xdotool getmouselocation --shell | grep "Y=" | awk -F "=" '{print $2}')
    local screen_width=1920
    local screen_height=1080
    local corner_width=50
    local corner_height=50

    if [ "$mouse_x" -ge "$((screen_width - corner_width))" ] && [ "$mouse_y" -le "$corner_height" ]; then
        return 0
    else
        return 1
    fi
}

###############################################################################

pre_lock

# We set a trap to kill the locker if we get killed, then start the locker and
# wait for it to exit. The waiting is not that straightforward when the locker
# forks, so we use this polling only if we have a sleep lock to deal with.
if [[ -e /dev/fd/${XSS_SLEEP_LOCK_FD:--1} ]]; then
	kill_i3lock() {
        revert
		pkill -xu $EUID "$@" i3lock
	}

	trap kill_i3lock TERM INT

	# we have to make sure the locker does not inherit a copy of the lock fd
    i3lock -i $screenshot_path --clock --date-pos="ix:iy+160" \
        --time-pos="ix:iy+140" \
        {XSS_SLEEP_LOCK_FD}<&-


	# now close our fd (only remaining copy) to indicate we're ready to sleep
	exec {XSS_SLEEP_LOCK_FD}<&-

	while kill_i3lock -0; do
	    sleep 0.5
	 done
else
    if ! is_mouse_in_corner; then
        trap 'kill %%' TERM INT
        i3lock -n -i $screenshot_path --clock --date-pos="ix:iy+160" \
            --time-pos="ix:iy+140" &
        #i3lock -n $i3lock_options &
        # waits until i3lock in the background has finished
        wait
    else
        echo 'mouse is in tr corner, not locking'
    fi
fi

post_lock
