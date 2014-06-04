#!/bin/bash
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
for f in `find "$THIS_DIR" -type f -name '*.sh'`
do
    . $f
done
