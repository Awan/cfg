#!/usr/bin/env python3

import json
from pathlib import Path
from appdirs import AppDirs
import os
import sys
from time import sleep


print("""

  ▓▓▓▓▓▓▓▓▓▓ 
 ░▓ Author ▓ Abdullah <https://abdullah.today> 
 ░▓▓▓▓▓▓▓▓▓▓ 
 ░░░░░░░░░░ 

""")

print("""
Usage:-
beautify <Path to wallpapers> <Duration>
""")

dirs = AppDirs('beautify', 'Abdullah')


def walls_path(path):
    try:
        with open(Path(dirs.user_config_dir)/'config', 'w+') as f:
            d = {}
            d['walls_dir'] = path
            json.dump(d, f)
            f.close()
    except FileNotFoundError:
        os.makedirs(dirs.user_config_dir)
        walls_path(path)


def getting_ready():
    try:
        with open(Path(dirs.user_config_dir)/'config', 'r') as f:
            fetch_data = json.load(f)
            walls_dir = fetch_data.get('walls_dir')
            return walls_dir

    except FileNotFoundError:
        return sys.exit(f"Please run {dirs.appname} with wallpapers path")
    except (KeyError, json.decoder.JSONDecodeError):
        os.remove(Path(dirs.user_config_dir)/'config')
        return sys.exit(f"""
        {dirs.appname} wasn't able to get correct data. Old configuration file
        is removed. Please run {dirs.appname} with wallpapers path again.
        """)


def start_it(duration=600):
    wallpapers = os.listdir(getting_ready())
    for i in range(len(wallpapers)):
        wallpapers[i] = str(Path(getting_ready()).joinpath(wallpapers[i]))
    while True:
        for i in wallpapers:
            os.system(f"feh --bg-scale '{i}'")
            sleep(duration)


try:
    if Path.is_dir(Path(sys.argv[1])):
        walls_path(sys.argv[1])
        getting_ready()
        start_it(int(sys.argv[2]))
    elif not Path.is_dir(Path(sys.argv[1])):
        print(sys.argv[1] + " isn't a directory. Please enter path of a directory.")
except ValueError:
    print("Please enter a digit for duration between wallpapers's changes")
except IndexError:
    start_it()
