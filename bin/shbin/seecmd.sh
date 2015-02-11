#!/bin/bash
usage="usage:
    seecmd <commandname>
        opens up the command from my bin for editing
"
die(){ echo "${usage}" >&2; exit 1; }

cmd=$1

[ -n "$cmd" ] || die

no_such_command="$(find $HOME/bin/ -name ${cmd} | sed 1q)"
no_such_ios_command="$(find $HOME/iOS-debug-bin/ -name ${cmd} | sed 1q)"
if [ -z "${no_such_command}" ] && [ -z "${no_such_ios_command}" ]; then
    echo "Command \"$cmd\" not found in ~/bin/."
    exit 1
fi

find $HOME/bin/ -name "${cmd}.sh" -exec vim {} \;
find $HOME/bin/ -name "${cmd}.py" -exec vim {} \;
find $HOME/iOS-debug-bin/ -name "${cmd}.sh" -exec vim {} \;
find $HOME/iOS-debug-bin/ -name "${cmd}.py" -exec vim {} \;
