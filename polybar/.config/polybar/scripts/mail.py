#!/usr/bin/env python

"""
In the name of Allah, the most Gracious, the most Merciful.

 ▓▓▓▓▓▓▓▓▓▓
░▓ Author ▓ Abdullah <https://abdullah.today>
░▓▓▓▓▓▓▓▓▓▓
░░░░░░░░░░

░█▀█░█▀█░█░░░█░█░█▀▄░█▀█░█▀▄
░█▀▀░█░█░█░░░░█░░█▀▄░█▀█░█▀▄
░▀░░░▀▀▀░▀▀▀░░▀░░▀▀░░▀░▀░▀░▀
"""

# Install dependencies
# pip install --upgrade google-api-python-client google-auth-httplib2 google-auth-oauthlib

import imaplib
import argparse
import subprocess
import time
from apiclient import errors
from httplib2 import ServerNotFoundError

get_mail, get_passwd, get_server = subprocess.run(['gpg', '-dq', '/home/ak/.local/share/misc/email_address.gpg'], check=True, stdout=subprocess.PIPE,
stderr=subprocess.PIPE, encoding='utf-8'), subprocess.run(['gpg','-dq',
    '/home/ak/.local/share/misc/mail_otp.gpg'],check=True,
    stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding='utf-8'), subprocess.run(['gpg', '-dq', '/home/ak/.local/share/misc/email_server.gpg'],
        check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding='utf-8')
mail_address, mail_passwd, mail_server = get_mail.stdout[:-1], get_passwd.stdout[:-1], get_server.stdout[:-1]
parser = argparse.ArgumentParser()
parser.add_argument('-b', '--badge', default='\uf0e0')
parser.add_argument('-c', '--color', default='#ff69b4')
parser.add_argument('-m', '--mute', action='store_true')
args = parser.parse_args()
unread_badge = '%{F' + args.color + '}' + args.badge + ' %{F-}'
error_badge = '%F' + args.color + '}\uf06a %{F-}'
mail_count_was = 0


def sync(mail_count):
    obj = imaplib.IMAP4_SSL(mail_server, 993)
    obj.login(mail_address, mail_passwd)
    obj.select()
    mail_count_now = len(obj.search(None, 'UnSeen')[1][0].split())
    if mail_count_now > 0:
        print(unread_badge + str(mail_count_now), flush=True)
    else:
        print(args.badge, flush=True)
    if not args.mute and mail_count_was < mail_count_now and mail_count_now > 0:
        subprocess.run(['/usr/bin/mbsync', '-Xa'], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        subprocess.run(['/usr/bin/mpv', '--no-resume-playback', '--volume=45',
            '--really-quiet', '/home/ak/.local/share/misc/phansi.aac' ])
    return mail_count_now


try:
    import httplib
except:
    import http.client as httplib


def is_connected():
    conn = httplib.HTTPConnection('mail.abdullah.today', timeout=3)
    try:
        conn.request('HEAD', '/')
        conn.close()
        return True
    except:
        conn.close()
        return False


while True:
#        time.sleep(5)
#    if is_connected():
#        mail_count_was = sync(mail_count_was)
#        time.sleep(10)
#    else:
#        print('no network!')
#        time.sleep(5)
        try:
            mail_count_was = sync(mail_count_was)
            time.sleep(10)
        except (errors.HttpError, ServerNotFoundError, OSError) as error:
            print(error_badge + str(error), flush=True)
            time.sleep(5)
