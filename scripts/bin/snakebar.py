#!/usr/bin/python3
import asyncio
import datetime
import subprocess
from dataclasses import dataclass

battery_percentage = ''
battery_icon = ''
time_remaining = ''
clock_time = ''
wifi_essid = ''
volume = ''


@dataclass
class StatusValues:
    battery_percentage: str = ''
    battery_icon: str = ''
    time_remaining: str = ''
    clock_time: str = ''
    wifi_essid: str = ''
    volume: str = ''


class StatusMgr:

    def __init__(self):
        self.handlers = {}
        self.values: StatusValues = StatusValues()
        self.update_event = asyncio.Event()

    def register_update_handler(self, name, interval=10):

        def __register(handler):
            if name not in self.handlers:
                # print(f'register handler {handler}')
                self.handlers[name] = {
                    'handler': handler,
                    'interval': interval
                }

            def __wrapped_handler(*args, **kwargs):
                return handler(*args, **kwargs)

            return __wrapped_handler

        return __register

    async def start_handlers(self):
        tasks = [asyncio.create_task(self.update_status_bar())]
        for name, settings in self.handlers.items():

            task = asyncio.create_task(
                self.run_handler(name, settings['handler'],
                                 settings['interval']))
            tasks.append(task)
        return await asyncio.gather(*tasks)

    async def run_handler(self, name, handler, interval):
        while True:
            try:
                value = await handler()
                if ',' in name:
                    names = name.split(',')
                    name_value = dict(zip(names, value))
                    for _name, value in name_value.items():
                        self.set_value(_name, value)
                else:
                    self.set_value(name, value)
                await asyncio.sleep(interval)
            except asyncio.CancelledError:
                print('cancelled')
                break

    def set_value(self, name, value):
        # print(f'setattr called with {name=} {value=}')
        # only set event when value changed
        if getattr(self.values, name) != value:
            self.values.__setattr__(name, value)
            self.update_event.set()

    # def __getattribute__(self, name):
    #     print(f'getattribute called with {name}')
    #     try:
    #         return super().__getattribute__(name)
    #     except Exception as exc:
    #         print(exc)
    #         raise

    def __getattr__(self, name):
        # print(f'getattr called with {name=}')
        return self.values.__getattr__(name)

    async def update_status_bar(self):
        while True:
            await self.update_event.wait()
            print(
                f'{self.values.wifi_essid}  {self.values.volume}  {self.values.battery_icon} {self.values.battery_percentage}% [{self.values.time_remaining}] \uf073 {self.values.clock_time}'
            )
            self.update_event.clear()


status_manager = StatusMgr()


@status_manager.register_update_handler(name='battery_percentage,battery_icon',
                                        interval=3)
async def get_battery():
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

    return battery_percentage, battery_icon


@status_manager.register_update_handler(name='time_remaining', interval=10)
async def remaining_time():
    res = subprocess.run(['/usr/bin/acpi -b | cut -d" " -f5'],
                         shell=True,
                         stdout=subprocess.PIPE)
    time_remaining = res.stdout.decode('utf-8').strip()
    return time_remaining


@status_manager.register_update_handler(name='clock_time', interval=1)
async def update_clock_time():
    now_dt = datetime.datetime.now()
    clock_time = now_dt.strftime('%Y-%m-%d %H:%M:%S')
    return clock_time


@status_manager.register_update_handler(name='wifi_essid', interval=5)
async def update_wifi():
    res = subprocess.run(['/usr/bin/essid', '-w', 'wlan0'],
                         stdout=subprocess.PIPE)
    wifi_essid = res.stdout.decode('utf-8').strip()
    if wifi_essid:
        wifi_essid = f'\uf1eb {wifi_essid}'
    return wifi_essid


@status_manager.register_update_handler(name='volume', interval=1)
async def update_volume():
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
    return volume


if __name__ == '__main__':
    try:
        asyncio.run(status_manager.start_handlers())
    except KeyboardInterrupt:
        print('User stopped snakebar')
