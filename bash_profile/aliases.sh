
if [ "$(uname -s)" == "Darwin" ]; then # on Mac
    alias ls='ls -GFh'
else # on Linux prob
    alias ls='ls -Fh --color=auto'
fi

alias g='grep -Ini'
alias v='vim'

# todo and diary
alias t='todo'
alias ta='todo add'
alias te='todo edit'
alias d='diary'
alias da='diary add'
alias de='diary edit'

# git
alias gs='git status'
alias gp='git pull'
alias GS='gs'
alias gc='git commit'
alias gca='git commit -a'
alias gcaa='git commit -a --amend'
alias gl="git log --graph --pretty=format:'%Cred%H%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --color=always"
alias glh="gl | head"
alias gspp="git stash; git pull --rebase; git stash pop"
alias grh='git reset --hard' # discards all changes in working dir
alias gdh='git diff HEAD~1 HEAD'
alias gsh="git stash"
alias gsp="git stash pop"
alias gds="git diff --staged"
alias github="open \`git config --get remote.origin.url | sed -E 's/^.*github\.com[:\/](.*)\.git$/https:\/\/github.com\/\1/'\`"

current_git_branch() {
    git branch | grep \* | awk '{ print $2 }'
}

# gd 1 shows the diff of the first modified file
gd() {
    if [ -z "$1" ]; then git diff
    elif [ -f "$1" ]; then git diff "$1"
    elif [ "$1" -gt 0 ]; then git diff "$(git ls-files --modified | sed -n $1p)"
    fi
}

#gdf some-git-sha will show the diff at that sha.
gdf() {
    git diff "$1"{~1,}
}

# ga 1 adds the first modified file
ga() {
    if [ -z "$1" ] || [ -e "$1" ] || [[ "$1" == -*  ]]; then git add "$@"
    elif [ "$1" -gt 0 ]; then git add  "$(git ls-files --modified | sed -n $1p)" 
    fi
}
# to "unadd" a change, use ga -i and then revert

# push or pull the current branch
gpush() {
    git push origin `current_git_branch`
}
gpull() {
    git pull origin `current_git_branch`
}

gri() {
    git rebase --interactive 'HEAD~'"$1"
}

# a smart git checkout, with no args it switches to last branch.
gch() {
    if [ -n "$1" ]; then 
        echo `current_git_branch` >"/tmp/last_git_branch_used.txt"
        git checkout "$@"
    else
        if [ ! -f "/tmp/last_git_branch_used.txt" ]; then echo >&2 "ERROR: Please run gch with 1 argument first."
        else
            echo `current_git_branch` >"/tmp/last_git_branch_used.temp"
            git checkout `cat /tmp/last_git_branch_used.txt`
            mv "/tmp/last_git_branch_used."{temp,txt}
        fi
    fi
    echo
    echo "GIT STATUS"
    echo "=========="
    gs
    echo
    echo "GIT LOG"
    echo "======="
    glh
}





# Notes
#
# The == comparison operator behaves differently within a double-brackets  test than within single brackets.
# 
# [[ $a == z* ]]   # True if $a starts with a "z" (wildcard matching).
# [[ $a == "z*" ]] # True if $a is equal to z* (literal matching).
