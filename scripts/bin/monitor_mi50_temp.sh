#!/usr/bin/env bash
# monitor_mi50_temp.sh
# Continuously monitor AMD MI50 GPU temperature

set -euo pipefail

# Check dependencies
if ! command -v rocm-smi &>/dev/null; then
  echo "Error: rocm-smi not found. Install with: sudo pacman -S rocm-smi"
  exit 1
fi

INTERVAL=${1:-5}  # seconds between updates

echo "Monitoring MI50 temperature every ${INTERVAL}s (press Ctrl+C to stop)"
echo "-------------------------------------------------------------"

# Loop forever
while true; do
  clear
  date '+%Y-%m-%d %H:%M:%S'
  echo "-------------------------------------------------------------"
  
  # Print temperature and power info
  rocm-smi --showtemp --showpower --showfan --showvoltage | grep -E "GPU\[[0-9]+\]|Temperature|Power|Fan|Voltage"
  
  sleep "$INTERVAL"
done

