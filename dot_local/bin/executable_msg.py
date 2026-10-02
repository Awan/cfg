#!/usr/bin/env python3
# coding: utf-8
#  ▓▓▓▓▓▓▓▓▓▓
# ░▓ Author ▓ Abdullah <https://abdullah.support/>
# ░▓▓▓▓▓▓▓▓▓▓
# ░░░░░░░░░░

# A simple program which sends messages to phone using twilio API

import argparse
import subprocess
from pathlib import Path

from twilio.rest import Client


MISC_DIR = Path.home() / '.local/share/misc'


def decrypt(name):
    result = subprocess.run(
        ['gpg', '-dq', str(MISC_DIR / name)],
        check=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )
    return result.stdout.rstrip('\n')


sid = decrypt('twilio_sid.gpg')
token = decrypt('twilio_token.gpg')
twilio_number = decrypt('twilio_number.gpg')
local_number = decrypt('local_number.gpg')

parser = argparse.ArgumentParser(description='A simple program which uses twilio API to send message to phone')
parser.add_argument('-b', '--body', type=str)
args = parser.parse_args()

obj = Client(sid, token)
message = obj.messages.create(body=args.body, from_=twilio_number, to=local_number)
