#!/usr/bin/env python3
# coding: utf-8
"""
Pictures taken from phones and cameras are usually have large in size.
This script will get some files from a directory and saves them back 
but with file size decreased. 

 ▓▓▓▓▓▓▓▓▓▓ 
░▓ Author ▓ Abdullah <https://abdullah.today> 
░▓▓▓▓▓▓▓▓▓▓ 
░░░░░░░░░░ 

The MIT License (MIT)
Copyright (c) 2019 Abdullah <abdullah@abdullah.today>
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

"""

import subprocess as sp
from PIL import Image

sp.os.makedirs('resized_images', exist_ok=True)

for files in sp.os.listdir('.'):
    if not (files.endswith('.jpg') or files.endswith('.png') or files.endswith('.jpeg')):
        continue
    obj = Image.open(files)
    print("Resizing and Saving %s..." % (files))
    obj.save(sp.os.path.join('resized_images', files))
