#!/usr/bin/env python3
# coding: utf-8
#  ▓▓▓▓▓▓▓▓▓▓ 
# ░▓ Author ▓ Abdullah <https://abdullah.today/> 
# ░▓▓▓▓▓▓▓▓▓▓ 
# ░░░░░░░░░░ 

# A simple program which sends messages to phone using twilio API

import subprocess
import argparse
from twilio.rest import Client

get_sid, get_token, get_twilio_number, get_local_number = subprocess.run(['gpg',
    '-dq', '/home/ak/.local/share/misc/twilio_sid.gpg'], check=True,
    stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding='utf-8'), subprocess.run(['gpg', '-dq', '/home/ak/.local/share/misc/twilio_token.gpg'],
    check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
    encoding='utf-8'), subprocess.run(['gpg', '-dq',
    '/home/ak/.local/share/misc/twilio_number.gpg'], check=True,
    stderr=subprocess.PIPE, stdout=subprocess.PIPE, encoding='utf-8'), subprocess.run(['gpg', '-dq',
    '/home/ak/.local/share/misc/local_number.gpg'], check=True,
    stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding='utf-8') 

sid, token, twilio_number, local_number = get_sid.stdout[:-1], get_token.stdout[:-1], get_twilio_number.stdout[:-1], get_local_number.stdout[:-1]

parser = argparse.ArgumentParser(description='A simple program which uses twilio API to send message to phone')
parser.add_argument('-b', '--body', type=str)
args = parser.parse_args()

obj = Client(sid, token)
message = obj.messages.create(body=args.body,
        from_=twilio_number, to=local_number)
