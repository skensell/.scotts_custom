#!/bin/bash

set -e

function link_or_warn(){
    local f=$(basename "$1")
    if [ -e "$HOME/$f" ]; then
        echo >&2 "$HOME/$f exists already. Skipping linking phase."
    else
        ln -sv "$1" "$HOME/$f"
    fi
}

cd "$HOME"
if [ -d '.scotts_custom' ]; then
    echo ".scotts_custom exists already, skipping cloning stage."
else
    git clone git@github.com:skensell/.scotts_custom.git 
fi
    

link_or_warn "$HOME/.scotts_custom/bash_profile/.bash_profile"
link_or_warn "$HOME/.scotts_custom/bin"
link_or_warn "$HOME/.scotts_custom/vim/.vimrc"
link_or_warn "$HOME/.scotts_custom/tmux/.tmux.conf"

if [ ! -e "$HOME/.vim/bundle/vundle" ]; then
    git clone git://github.com/gmarik/vundle.git $HOME/.vim/bundle/vundle
fi

echo "Bootstrap successful. If you want to finish the vim setup, run: vim +BundleInstall +qall"
