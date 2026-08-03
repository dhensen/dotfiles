#!/usr/bin/env bash
set -euo pipefail

# Ensure we're inside tmux
if [[ -z "${TMUX:-}" ]]; then
  echo "Please run this from inside an existing tmux session." >&2
  exit 1
fi

# Create a new window named "fans"
tmux new-window -n fans

# Pane 1 (top-left): sensors watcher
tmux send-keys 'watch -n1 sensors it8792-isa-0a60' C-m

# Split horizontally for Pane 2 (top-right): pwm3 watcher
tmux split-window -h
tmux send-keys 'watch -n0.1 -- cat /sys/class/hwmon/hwmon4/pwm3' C-m

# Split Pane 1 vertically for Pane 3 (bottom-left): fancontrol (sudo)
tmux select-pane -L   # go back to left/top pane
tmux split-window -v
tmux send-keys 'sudo fancontrol' C-m

# Split Pane 2 vertically for Pane 4 (bottom-right): blank for typing
tmux select-pane -R   # go to right/top pane
tmux split-window -v
# leave this pane blank for manual commands

# Make it tidy
tmux select-layout tiled
tmux select-pane -L   # put cursor on the blank pane (bottom-right after tiled may vary)

