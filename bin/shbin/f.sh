#!/bin/bash
usage="usage:
    f pattern
        find . -name '*pattern*'
"
die(){ echo "${usage}" >&2; exit 1; }

[ -z "$1" ] && die

find . -name "*$1*"
