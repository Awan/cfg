#!/usr/bin/env python
"""
In the name of Allah, the most Gracious, the most Merciful.

 ▓▓▓▓▓▓▓▓▓▓
░▓ Author ▓ Abdullah <https://abdullah.today>
░▓▓▓▓▓▓▓▓▓▓
░░░░░░░░░░

░█░█░▀█▀░▀▀█░█▀▄░▀█▀░░░█▀▄░█▀█░▀█▀░█▀▀░█▀▀
░█▀█░░█░░░░█░█▀▄░░█░░░░█░█░█▀█░░█░░█▀▀░▀▀█
░▀░▀░▀▀▀░▀▀░░▀░▀░▀▀▀░░░▀▀░░▀░▀░░▀░░▀▀▀░▀▀▀
"""


from hijri_converter import convert

month_names_in_en = {
  1: 'Muharram',
  2: 'Safar',
  3: 'Rabi-I',
  4: 'Rabi-II',
  5: 'Jumada-I',
  6: 'Jumada-II',
  7: 'Rajab',
  8: 'Shaban',
  9: 'Ramadan',
  10: 'Shawwal',
  11: 'Zu-al-Qadah',
  12: 'Zu-al-Hijjah',
  }

day_names_in_en = {
        1: 'Ithnayn',
        2: 'Thulatha',
        3: 'Arbaa',
        4: 'Khamis',
        5: 'Jummah',
        6: 'Sabt',
        7: 'Ahad',
        }



today = convert.Gregorian.today().to_hijri()


def get_day():
    day_of_week = today.isoweekday()

    return day_names_in_en[day_of_week]

def get_month():
    month = today.month

    return month_names_in_en[month]

print(get_day(), get_month(), today.day)
