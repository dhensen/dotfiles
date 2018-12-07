#!/usr/bin/env python3

import configparser

config = configparser.ConfigParser()
config.read('/home/dhensen/cert_enabled_sites.ini')

def _format_domain_entry(domain):
    return ['-d', domain]

commands = []
for section in config.sections():
    command = ['sudo', 'certbot', '--apache', '--redirect']
    for domain in config[section].values():
        command = command + _format_domain_entry(domain)

    commands.append(command)

print(" && ".join(map(lambda cmd: " ".join(cmd), commands)))
