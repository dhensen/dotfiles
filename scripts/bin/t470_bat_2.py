#!/usr/bin/python3

from pathlib import Path

BAT0 = Path('/sys/class/power_supply/BAT0/uevent')
BAT1 = Path('/sys/class/power_supply/BAT1/uevent')


def parse_uevent(uevent: str):
    return dict([line.split('=') for line in uevent.splitlines()])


uevent0 = parse_uevent(BAT0.read_text())
uevent1 = parse_uevent(BAT1.read_text())

# print(uevent0, uevent1)

total_energy = int(uevent0['POWER_SUPPLY_ENERGY_FULL']) + int(
    uevent1['POWER_SUPPLY_ENERGY_FULL'])

factor0 = int(uevent0['POWER_SUPPLY_ENERGY_FULL']) / total_energy
factor1 = int(uevent1['POWER_SUPPLY_ENERGY_FULL']) / total_energy

capacity0 = int(uevent0['POWER_SUPPLY_CAPACITY'])
capacity1 = int(uevent1['POWER_SUPPLY_CAPACITY'])
# print(factor0, factor1)

capacity_left = round(factor0 * capacity0 + factor1 * capacity1)

print(capacity_left)
