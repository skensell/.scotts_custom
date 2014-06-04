#!/bin/bash
usage="usage:
    removecmd <commandname>
        removes commands I've made safely. This is the inverse of makecmd.
"
die(){ echo "${usage}" >&2; exit 1; }

cmd=$1

[ -n "$cmd" ] || die

echo "Deleted:"

rm -vf ${HOME}/bin/${cmd}
rm -vf ${HOME}/bin/pybin/${cmd}.py
rm -vf ${HOME}/bin/shbin/${cmd}.sh



