#!/usr/bin/env bash
set +o noclobber
#
#   $1 = scanner device
#   $2 = friendly name
#

# scanimage -L reported resolutions:
# 100|150|default:200|300|400|600|1200|2400|4800|9600dpi
#
resolution=200
device=${1:-"brother4:net1;dev0"}
mkdir -p ~/brscan
sleep  0.1

output_format=~/brscan/brscan_"`date +%Y-%m-%d_%H-%M-%S`""_%d.png"
echo "scan from $2($device) to $output_format"

scanimage \
  --batch="$output_format" \
  --format=png \
  --batch-print \
  --device-name="$device" \
  --source="Automatic Document Feeder(left aligned,Duplex)" \
  --resolution=$resolution \
  -x 209.981 \
  -y 296.973

echo "scanning done"
