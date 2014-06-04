#!/bin/bash
usage="usage:
    idea
        a simple wrapper to bring intellij to the front when opened
"
die(){ echo "${usage}" >&2; exit 1; }

/usr/local/bin/idea ~/bin/ "$@"
open /Applications/IntelliJ\ IDEA\ 13\ CE.app

