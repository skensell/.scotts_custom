#!/bin/bash
usage="usage:
    repeat num_times command args
        self explanatory
"
die(){ echo "${usage}" >&2; exit 1; }

num_times=$1; shift
cmd=$1; shift

([ -z $num_times ] || [ -z $cmd ]) && die

for ((i=1; i<=$num_times; i++)); do
    $cmd "$@"
done

