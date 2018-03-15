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

function prompt_to_install_essential_software {
    read -r -p "Do you want to install essential software like brew and rvm? [y/n] " response
    case $response in
        [yY][eE][sS]|[yY]) install_essential_software ;;
        *) echo "Skipping software install." ;;
    esac
}

function install_essential_software() {
    # Ruby Version Manager
    if [[ ! -s "$HOME/.rvm/scripts/rvm" ]]; then
        \curl -sSL https://get.rvm.io | bash -s stable
    fi

    # Brew
    if [[ -z "$(which brew >/dev/null)" ]]; then
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    # the vim shipped with mac doesnt have clipboard support
    brew install vim
}

if [ ! -d "$HOME/.scotts_custom" ]; then
    echo >&2 "ERROR: $HOME/.scotts_custom does not exist"
    exit 1
fi
    
prompt_to_install_essential_software

link_or_warn "$HOME/.scotts_custom/bash_profile/.bash_profile"
link_or_warn "$HOME/.scotts_custom/bin"
link_or_warn "$HOME/.scotts_custom/vim/.vimrc"
link_or_warn "$HOME/.scotts_custom/tmux/.tmux.conf"
link_or_warn "$HOME/.scotts_custom/git/.gitconfig"
link_or_warn "$HOME/.scotts_custom/irbrc/.irbrc"

if [ ! -e "$HOME/.vim/bundle/vundle" ]; then
    git clone git://github.com/gmarik/vundle.git $HOME/.vim/bundle/vundle
fi

echo "Bootstrap successful. If you want to finish the vim setup, run: vim +BundleInstall +qall"
echo "Also, don't forget to source .bash_profile"
