#!/bin/bash
usage="usage:
    whatimade
        does black magic
"
die(){ echo "${usage}" >&2; exit 1; }

[ -n "$1" ] && echo "My whole bin:" && ls -tU $HOME/bin | cat && exit 0

echo "The last 10 general commands I've made:"
ls -tU $HOME/bin | head

echo
echo "The last 10 iOS commands I've made:"
ls -tU $HOME/iOS-debug-bin | head
