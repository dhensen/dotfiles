#!/bin/bash
while true; do
    find -L ~/Pictures/Wallpapers -maxdepth 1 -type f \( -name '*.jpg' -o -name '*.png' \) -print0 | shuf -n1 -z | xargs -0 -I {} feh --bg-fill "{}"
    sleep 2m
done
