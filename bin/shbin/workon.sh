#!/bin/bash
usage="usage:
	workon project
		creates the TODO list and diary for the project if it doesn't exist already and then sets those as current.
	workon
		shows a list of all projects to work on
"
die(){ echo "${usage}" >&2 ; exit 1; }

list_projects(){
	echo All current projects:
	ls ~/notes/*todo.txt | xargs basename | grep -v current | sed "s/.todo.txt//"
	exit 0
}

[ -z $1 ] && list_projects

[ $1 = "-h" ] && die

# when given a project name

todo set $1 >/dev/null 2>/dev/null || { todo create $1; todo set $1; }
diary set $1 >/dev/null 2>/dev/null || { diary create $1; diary set $1; echo "New project $1 created."; }

FGRN="\033[32m" # foreground green
RS="\033[0m"    # reset color
# see http://misc.flogisoft.com/bash/tip_colors_and_formatting for color tips

echo -e "${FGRN}TODO for $1 as found in ~/notes/$1.todo.txt${RS}"
todo
echo
echo -e "${FGRN}DIARY for $1 as found in ~/notes/$1.diary.txt${RS}"
diary