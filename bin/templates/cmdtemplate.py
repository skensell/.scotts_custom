#!/usr/bin/env python
import re
import sys
import argparse


def cmd(file):
    f = open(file, 'r') if file else sys.stdin
    new_file = ''
    for line in f.readlines():

        new_file += line

    f.close()

    print new_file


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="does black magic")

    # required args

    # optional args
    parser.add_argument("--file", "-f",
                        help="the file to manipulate (stdin by default)")

    args = parser.parse_args()
    cmd(args.file)
