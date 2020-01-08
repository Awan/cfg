#!/usr/bin/env python3
# coding=utf-8

#  ▓▓▓▓▓▓▓▓▓▓ 
# ░▓ Author ▓ Abdullah <https://abdullah.today/> 
# ░▓▓▓▓▓▓▓▓▓▓ 
# ░░░░░░░░░░ 

# This script pastes a file's content to https://bpaste.net with python syntax highlightings and returns with URL. 
# URL with python syntax highlightings gets copied into clipbaord.

import requests
import subprocess as sp

SERVICE = 'https://bpaste.net'
LEXER = sp.sys.argv[2]


def log(*args):
    print(*args, file=sp.sys.stderr)


def post(text):
    rs = requests.post(f'{SERVICE}/json/new', data=dict(code=text, lexer=f'{LEXER}', expiry='1week'))
    return rs.json()['paste_id']


def main():
    path = sp.sys.argv[1]
    with open(path) as file:
        paste_id = post(file.read())
    #log(f'{SERVICE}/show/{paste_id}')
    log(f'{SERVICE}/raw/{paste_id}')
    sp.run(['xclip', '-r'], input=f'{SERVICE}/show/{paste_id}\n', encoding='utf-8')
    


if __name__ == '__main__':
    main()
