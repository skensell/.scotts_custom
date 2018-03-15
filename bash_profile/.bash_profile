#!/bin/bash
##THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
THIS_DIR=$HOME/.scotts_custom/bash_profile
for f in `find "$THIS_DIR" -type f -name '*.sh'`
do
    . $f
done

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

if [ -d "$HOME/p/fluff/bin" ]; then
    export PATH=${PATH}:"$HOME/p/fluff/bin"
fi

export MYSQL_PATH=/usr/local/Cellar/mysql/5.7.17
export PATH=$PATH:$MYSQL_PATH/bin
