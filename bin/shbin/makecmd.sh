#!/bin/bash
usage="usage:
    makecmd [-p] [-f] <commandname>
        creates a symlink in ~/bin to a command in ~/bin/pybin or ~/bin/shbin
"
die(){ echo "${usage}" >&2; exit 1; }

cmd=$1

[[ $cmd == -p ]] && is_python=true && { shift; cmd=$1; }
[[ $cmd == -f ]] && force=true && { shift; cmd=$1; }

[ -n "$cmd" ] || die

which ${cmd} >/dev/null && [ -z ${force} ] && echo "ERROR: The command $cmd already exists." >&2 && exit 1

case ${is_python} in
    true)
        cmdpath="$HOME/bin/pybin/${cmd}.py"
        cp $HOME/bin/templates/cmdtemplate.py ${cmdpath}
        line_number=10                                  ;;
    *)
        cmdpath="$HOME/bin/shbin/${cmd}.sh"
        cp $HOME/bin/templates/cmdtemplate.sh ${cmdpath}
        line_number=8                                   ;;
esac

chmod +x $cmdpath
sed -i '' "s/cmd/${cmd}/g" ${cmdpath}

ln -sf "${cmdpath}" "$HOME/bin/${cmd}"

vim  "${cmdpath}"
