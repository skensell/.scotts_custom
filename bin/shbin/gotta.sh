#!/bin/bash

usage="
This is a tool for the 'in' and 'collect' phases of the 'get-it-done' philosophy.

usage:
	gotta
        shows everything collected in the gotta file
    gotta edit
        open the gotta file for editing
    gotta msg
        add msg with timestamp to the gotta file
"
die(){ echo "${usage}" >&2; exit 1; }

# TODO : make an api for the organize command

gottafile="$HOME/notes/gotta.txt"

setup(){ touch $gottafile; }
is_already_setup(){ [ -f $gottafile ]; }
is_already_setup || setup

msg="$*"

case $msg in
    -h) die ;;
    '')
        cat $gottafile
    ;;
    edit)
        mate $gottafile
    ;;
    *) 
		echo "$msg
" >>$gottafile
    ;;
esac

