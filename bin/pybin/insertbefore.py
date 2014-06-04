#!/usr/bin/env python
import re
import sys
import argparse

def insertbefore(pattern, text, file):

    f = open(file, 'r') if file else sys.stdin
    regexp = re.compile(pattern)

    new_file = ''
    for line in f.readlines():
        m = regexp.match(line)
        if m:
            new_file += formatted_text(m, text)

        new_file += line

    f.close()

    print new_file

def formatted_text(match, text):
    segments = re.split(r"\\\d", text)
    groups = re.findall(r"\\\d", text)
    groups = map(lambda x: int(x.replace('\\', '')), groups)

    return '%s'.join(segments) % tuple(match.group(g) for g in groups) + '\n'




if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="inserts text preceding a line which matches pattern")
    parser.add_argument("pattern",
                        help="a python regexp to match a line against (starting from beginning of line)")
    parser.add_argument("text",
                        help="the text to insert before the matched line (\\k refers to the kth matched group)")
    parser.add_argument("--file", "-f",
                        help="the file to manipulate (stdin by default)")
    args = parser.parse_args()

    insertbefore(args.pattern, args.text, args.file)
