#!/usr/bin/python3
import asyncio
import datetime
from operator import sub
import subprocess

battery_percentage = ''
battery_icon = ''
time_remaining = ''
clock_time = ''
wifi_essid = ''
volume = ''


async def get_battery():
    global battery_percentage, battery_icon
    while True:
        res = subprocess.run(
            ['/usr/bin/cat', '/sys/class/power_supply/BAT0/capacity'],
            stdout=subprocess.PIPE)
        battery_percentage = res.stdout.decode('utf-8').strip()
        try:
            battery_percentage = int(battery_percentage)
        except ValueError:
            battery_percentage = 0

        icon = ''
        if battery_percentage >= 75:
            icon = '\uf240'
        elif battery_percentage >= 50:
            icon = '\uf241'
        elif battery_percentage >= 25:
            icon = '\uf242'
        elif battery_percentage >= 0:
            icon = '\uf244'
        battery_icon = icon

        await update_status_barr()
        await asyncio.sleep(30)


async def remaining_time():
    global time_remaining
    while True:
        res = subprocess.run(['/usr/bin/acpi -b | cut -d" " -f5'],
                             shell=True,
                             stdout=subprocess.PIPE)
        time_remaining = res.stdout.decode('utf-8').strip()
        await update_status_barr()
        await asyncio.sleep(10)


async def update_clock_time():
    global clock_time
    while True:
        now_dt = datetime.datetime.now()
        clock_time = now_dt.strftime('%Y-%m-%d %H:%M:%S')
        await update_status_barr()
        await asyncio.sleep(1)


async def update_wifi():
    global wifi_essid
    while True:
        res = subprocess.run(['/usr/bin/essid', '-w', 'wlp2s0'],
                             stdout=subprocess.PIPE)
        wifi_essid = res.stdout.decode('utf-8').strip()
        if wifi_essid:
            wifi_essid = f'\uf1eb {wifi_essid}'
        await update_status_barr()
        await asyncio.sleep(5)


async def update_volume():
    global volume
    while True:
        res = subprocess.run(['/home/dino/bin/volumectl', 'get'],
                             stdout=subprocess.PIPE)
        volume = res.stdout.decode('utf-8').strip()
        res = subprocess.run(['/home/dino/bin/volumectl', 'is-muted'],
                             stdout=subprocess.PIPE)
        is_muted = res.stdout.decode('utf-8').strip()
        volume = int(volume)

        volume_icon = '\uf028'
        if is_muted == 'yes':
            # volume_icon = '\uf025'
            volume_icon = '\uf6a9'
        elif volume < 50:
            volume_icon = '\uf027'
        if volume == 0:
            volume_icon = '\uf026'

        volume = f'{volume_icon} {volume}'
        await update_status_barr()
        await asyncio.sleep(1)


async def update_status_barr():
    global battery_percentage, time_remaining, clock_time, battery_icon
    print(
        f'{wifi_essid}  {volume}  {battery_icon} {battery_percentage}% [{time_remaining}] \uf073 {clock_time}'
    )


async def update_status_bar():
    tasks = [
        asyncio.create_task(get_battery()),
        asyncio.create_task(remaining_time()),
        asyncio.create_task(update_clock_time()),
        asyncio.create_task(update_wifi()),
        asyncio.create_task(update_volume()),
    ]
    await asyncio.gather(*tasks)


if __name__ == '__main__':
    try:
        asyncio.run(update_status_bar())
    except KeyboardInterrupt:
        print('kaboom')
