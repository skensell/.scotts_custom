#!/usr/bin/env python
import re
import sys
import argparse

def catperline(delim, file1, file2):
    f = open(file1, 'r') if file1 != '-' else sys.stdin
    g = open(file2, 'r')
    new_file = ''
    for left in f.readlines():
        right = g.readline() or '\n'
        new_file += left.rstrip('\n') + (delim or '') + right

    for right in g.readlines():
        new_file += right

    f.close()
    g.close()

    print new_file


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="outputs file1 side by side with file2 with an optional delimiter")
    parser.add_argument("--delimiter", "-d",
                        help="a string to join the two lines with")
    parser.add_argument("file1",
                        help="its lines will appear on left (- marks stdin)")
    parser.add_argument("file2",
                        help="its lines appear to the right")
    args = parser.parse_args()

    catperline(args.delimiter, args.file1, args.file2)
