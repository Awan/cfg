#!/usr/bin/env python


import argparse
import fnmatch
import os
import sys

#  Recursively generate index.html files for
#  all subdirectories in a directory tree

index_file_name = 'index.html'

CSS = """ <style>

body {
    background: #f4f4f4;
    margin: 2em 1.5em;
}
/*
body {
    margin: 20px;
    background: #f5f5f5;
    -webkit-box-shadow: rgba(89, 89, 89, 0.449219) 2px 1px 9px 0px;
    -moz-box-shadow: rgba(89, 89, 89, 0.449219) 2px 1px 9px 0px;
    box-shadow: rgba(89, 89, 89, 0.449219) 2px 1px 9px 0px;
    border-radius: 11px;
    -moz-border-radius: 11px;
    -webkit-border-radius: 11px;
    height: 100%;
    min-height: 100%;
}
*/
li {
    font-family: sans-serif;
    font-size: 12pt;
    line-height: 14pt;
    list-style:none;
    list-style-type:none;
    padding: 3px 10px;
    margin: 3px 15px;
    display: block;
    clear:both;
}

.content {
    width: 600px;
    background-color: white;
    margin-bottom: 5em;
    padding-bottom: 3em;
    -webkit-box-shadow: rgba(89, 89, 89, 0.449219) 2px 1px 9px 0px;
    -moz-box-shadow: rgba(89, 89, 89, 0.449219) 2px 1px 9px 0px;
    box-shadow: rgba(89, 89, 89, 0.449219) 2px 1px 9px 0px;
    border: 0;
    border-radius: 11px;
    -moz-border-radius: 11px;
    -webkit-border-radius: 11px;
    height: 96%;
    min-height: 90%;
}


.size {
    float: right;
    color: gray;
}

h1 {
    padding: 10px;
    margin: 15px;
    font-size:13pt;
    border-bottom: 1px solid lightgray;
}

a {
    font-weight: 500;
    perspective: 600px;
    perspective-origin: 50% 100%;
    transition: color 0.3s;
    text-decoration: none;
    color: #060606;
}

a:hover,
a:focus {
    color: #e74c3c;
}

a::before {
    background-color: #fff;
    transition: transform 0.2s;
    transition-timing-function: cubic-bezier(0.7,0,0.3,1);
    transform: rotateX(90deg);
    transform-origin: 50% 100%;
}

a:hover::before,
a:focus::before {
    transform: rotateX(0deg);
}

a::after {
    border-bottom: 2px solid #fff;
}

 </style>
"""


def process_dir(top_dir, opts):
    for parentdir, dirs, files in os.walk(unicode(top_dir)):

        if not opts.dryrun:
            index_file = open(os.path.join(parentdir, index_file_name), "w")
            index_file.write('''<!DOCTYPE html>
    <html>
     <head>{css}</head>
     <body>
      <div class="content">
       <h1>{curr_dir}</h1>
       <li><a style="display:block; width:100%" href="..">&#x21B0;</a></li>'''.format(
                css=CSS,
                curr_dir=os.path.basename(os.path.abspath(parentdir).encode('utf8'))
            )
            )

        for dirname in sorted(dirs):

            absolute_dir_path = os.path.join(parentdir, dirname)

            if not os.access(absolute_dir_path, os.W_OK):
                print("***ERROR*** folder {} is not writable! SKIPPING!".format(absolute_dir_path))
                continue
            if opts.verbose:
                print('DIR:{}'.format(absolute_dir_path))

            if not opts.dryrun:
                index_file.write("""
       <li><a style="display:block; width:100%" href="{link}">&#128193; {link_text}</a></li>""".format(
                    link=dirname.encode('utf8'),
                    link_text=dirname.encode('us-ascii', 'xmlcharrefreplace')))

        for filename in sorted(files):

            if opts.filter and not fnmatch.fnmatch(filename, opts.filter):
                if opts.verbose:
                    print('SKIP: {}/{}'.format(parentdir, filename))
                continue

            if opts.verbose:
                print('{}/{}'.format(parentdir, filename))
            filename_escaped = filename.encode('us-ascii', 'xmlcharrefreplace')
            filename_utf8 = filename.encode('utf8')

            if filename.strip().lower() == index_file_name.lower():
                continue

            try:
                size = int(os.path.getsize(os.path.join(parentdir, filename)))

                if not opts.dryrun:
                    index_file.write(
    """
       <li>&#x1f4c4; <a href="{link}">{link_text}</a><span class="size">{size}</span></li>""".format(
                  link=filename_utf8,
                                link_text=filename_escaped,
                                size=pretty_size(size))
                    )

            except Exception as e:
                print('ERROR writing file name:', e)
                print('filename_utf8:')
                repr(filename_utf8)
                print('filename_escaped:'),
                repr(filename_escaped)

        if not opts.dryrun:
            index_file.write("""
  </div>
 </body>
</html>""")
            index_file.close()


# bytes pretty-printing
UNITS_MAPPING = [
    (1024 ** 5, ' PB'),
    (1024 ** 4, ' TB'),
    (1024 ** 3, ' GB'),
    (1024 ** 2, ' MB'),
    (1024 ** 1, ' KB'),
    (1024 ** 0, (' byte', ' bytes')),
]


def pretty_size(bytes, units=UNITS_MAPPING):
    """Human-readable file sizes.

    ripped from https://pypi.python.org/pypi/hurry.filesize/
    """
    for factor, suffix in units:
        if bytes >= factor:
            break
    amount = int(bytes / factor)

    if isinstance(suffix, tuple):
        singular, multiple = suffix
        if amount == 1:
            suffix = singular
        else:
            suffix = multiple
    return str(amount) + suffix

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='''DESCRIPTION:
    Generate directory index files recursively.
    Start from current dir or from folder passed as first positional argument.
    Optionally filter by file types with --filter "*.py". ''')

    parser.add_argument('top_dir',
                        nargs='?',
                        action='store',
                        help='top folder from which to start generating indexes, '
                             'use current folder if not specified',
                        default=os.getcwd())

    parser.add_argument('--filter', '-f',
                        help='only include files matching glob',
                        required=False)

    parser.add_argument('--verbose', '-v',
                        action='store_true',
                        help='***WARNING: this can take a very long time with complex file tree structures***'
                             ' verbosely list every processed file',
                        required=False)

    parser.add_argument('--dryrun', '-d',
                        action='store_true',
                        help="don't write any files, just simulate the traversal",
                        required=False)

    config = parser.parse_args(sys.argv[1:])


    process_dir(config.top_dir, config)
