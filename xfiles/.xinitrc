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

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

xsetroot -cursor_name left_ptr
xset r rate 220 30
eval $(ssh-agent)
redshift -m randr -r -l 52.0685:4.5094 -t 5700:3000 &
compton --config ~/.config/compton.conf -CGb
#conky &

monitor_count=$(xrandr | grep -c " connected")
if [ $monitor_count == 2 ]; then
     # Upscale HDMI1
#    xrandr --output HDMI1 --scale 2x2 --mode 1920x1080 --fb 7680x2160 --pos 0x0 --left-of eDP1
#    xrandr --output eDP1 --scale 1x1 --pos 3840x0

    # Downscale eDP1, because the 7680x2160 is too much for the integrated GPU
    xrandr --output HDMI1 --scale 1x1 --mode 1920x1080 --fb 3840x1080 --pos 0x0 --left-of eDP1
    xrandr --output eDP1 --scale 0.5x0.5 --pos 1920x0
    xrdb -merge ./.Xresources.standing
else
    xrandr --dpi 192
fi


export HDPI_SCALE_FACTOR=$(echo "$(xrdb -query | grep dpi | grep -o '[0-9]*') / 96" | bc)

sxhkd &
exec bspwm
