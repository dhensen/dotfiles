#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
	xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
	xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
	xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
	xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

xsetroot -cursor_name left_ptr
# toggle between us and us+alt-intl (deadkeys) with shift+toggle
setxkbmap -layout us,us -variant ,alt-intl -option grp:shifts_toggle
xset r rate 180 30
# gammastep -m wayland -r -l 52.0685:4.5094 -t 5700:2700 -v &!
#eval $(ssh-agent)
#redshift -m randr -r -l 52.0685:4.5094 -t 5700:3000 &
#picom --config ~/.config/picom.conf -CG &
#conky &
#[ ! -s ~/.config/mpd/pid ] && mpd

export HIDPI_SCALE_FACTOR=$(echo "$(xrdb -query | grep dpi | grep -o '[0-9]*') / 96" | bc)

export _JAVA_AWT_WM_NONREPARENTING=1
java_nonreparenting_wm_hack.sh

exec bspwm
