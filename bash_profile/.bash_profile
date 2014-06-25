#!/bin/bash
##THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
THIS_DIR=$HOME/.scotts_custom/bash_profile
for f in `find "$THIS_DIR" -type f -name '*.sh'`
do
    . $f
done
