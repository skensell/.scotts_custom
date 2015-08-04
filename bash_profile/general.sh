PATH="/usr/local/bin:$PATH"
PATH=/$HOME/anaconda/bin:$PATH
PATH=:$HOME/bin:$PATH
export PATH

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# ANSI color codes
RS="\[\033[0m\]"    # reset
HC="\[\033[1m\]"    # hicolor
UL="\[\033[4m\]"    # underline
INV="\[\033[7m\]"   # inverse background and foreground
FBLK="\[\033[30m\]" # foreground black
FRED="\[\033[31m\]" # foreground red
FGRN="\[\033[32m\]" # foreground green
FYEL="\[\033[33m\]" # foreground yellow
FBLE="\[\033[34m\]" # foreground blue
FMAG="\[\033[35m\]" # foreground magenta
FCYN="\[\033[36m\]" # foreground cyan
FWHT="\[\033[37m\]" # foreground white

# to achieve bold, don't mess around with tput, just use the 1; color code
# see http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html for example
FBLKBOLD="\[\033[1;30m\]" # foreground black bold

BBLK="\[\033[40m\]" # background black
BRED="\[\033[41m\]" # background red
BGRN="\[\033[42m\]" # background green
BYEL="\[\033[43m\]" # background yellow
BBLE="\[\033[44m\]" # background blue
BMAG="\[\033[45m\]" # background magenta
BCYN="\[\033[46m\]" # background cyan
BWHT="\[\033[47m\]" # background white


PS1="${FBLKBOLD}ː \w ${RS}\$(~/bin/vcprompt -f '[${FCYN}%n${RS}:${FGRN}%b${RS}:${FCYN}%h%m%a%u${RS}] ')${FBLKBOLD}ː ${RS}"
export PS1

# ignores duplicates in history
export HISTCONTROL=ignoredups

# install brew
 
[[ -f /usr/local/bin/brew ]] || ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"

# for autojump command (j)
[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

# To be able to remap C-s in vim I need to disable the start/stop option
stty -ixon

# Turn on vim-like command line editing
set -o vi

export EDITOR=vim
