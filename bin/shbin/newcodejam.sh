#!/bin/bash
usage="usage:
    newcodejam <problem_name>
        creates a Python script skeleton for a google code jam question in the current dir
"
die(){ echo "${usage}" >&2; exit 1; }

[ -n "$1" ] || die
name=$(sed 's/.py//' <<<"$1")

cp "${HOME}/bin/templates/codejamtemplate.py" "${name}".py
vim "${name}".py

