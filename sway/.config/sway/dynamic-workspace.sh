#!/bin/bash

set -x

# Detect active outputs
outputs=$(swaymsg -t get_outputs | jq -r '.[] | select(.active) | .name')

# Exit if no outputs found
if [ -z "$outputs" ]; then
    notify-send "Sway Workspace Script" "No active outputs detected!"
    exit 1
fi

# Prepare output names as a comma-separated string for easy manual editing
output_list=$(echo "$outputs" | tr '\n' ',' | sed 's/,$//')

# Ask the user to reorder manually
ordered_outputs=$(zenity --entry --title="Arrange Monitors" \
    --text="Enter outputs in order (comma-separated):" \
    --entry-text="$output_list")

# If user cancels, exit
if [ -z "$ordered_outputs" ]; then
    exit 1
fi

# Convert ordered list to array
IFS=',' read -r -a output_array <<< "$ordered_outputs"

# Ensure we still have valid outputs
if [ ${#output_array[@]} -eq 0 ]; then
    notify-send "Sway Workspace Script" "No valid outputs selected!"
    exit 1
fi

# Debugging: Print selected outputs
echo "Selected output order: ${output_array[@]}"

# Distribute 10 workspaces among outputs
total_outputs=${#output_array[@]}
workspaces=(1 2 3 4 5 6 7 8 9 10)

# Calculate workspace split
workspaces_per_output=$((10 / total_outputs))
extra_workspaces=$((10 % total_outputs))  # Give the first output extra if uneven

# Assign workspaces to outputs
ws_index=0
for ((i = 0; i < total_outputs; i++)); do
    output="${output_array[i]}"
    num_workspaces=$workspaces_per_output

    # Give the first output the extra workspace if needed
    if [ $i -eq 0 ]; then
        num_workspaces=$((num_workspaces + extra_workspaces))
    fi

    for ((j = 0; j < num_workspaces; j++)); do
        swaymsg "workspace ${workspaces[$ws_index]} output $output"
        ((ws_index++))
    done
done

notify-send "Sway Workspace Assignment" "Workspaces assigned based on selected monitor order!"

