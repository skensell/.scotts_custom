#!/bin/bash

usage="usage:
	diary
		shows the most recent diary entries, equivalent to 'diary all | head -20'
	diary add some memo
		adds some memo to the current diary with a timestamp
	diary new
		opens the editor for adding entries with a timestamp
	diary edit [project]
		opens up vim to edit the current diary or a specific project's diary
	diary all
		shows all entries, i.e. cat ~/notes/current.diary.txt

API used by workon command:
	diary create project
		creates the diary for a new project
	diary set project
		symlinks ~/notes/project.diary.txt to the current diary at ~/notes/current.diary.txt
"
die(){ echo "${usage}" >&2; exit 1; }

currentdiary="$HOME/notes/current.diary.txt"

cmd=$1; shift
projectname=$1; shift

projdiary="$HOME/notes/${projectname}.diary.txt"

case $cmd in
	-h) die ;;
	create)
		[ -f $projdiary ] && { echo $projdiary exists already >&2; exit 1; }
		echo "Diary for $projectname

" >$projdiary
	;;
	edit)
		[ -z $projectname ] && vim $currentdiary && exit 0
		vim $projdiary
	;;
	set) 
		[ -z $projectname ] && die
		[ -f $projdiary ] || { echo "you should run diary create first" >&2; die; }
		ln -s -f $projdiary $currentdiary
	;;
	add)
		msg="$projectname $*"
		[ "$msg" = ' ' ] && die
		
		timestamp="[$(date | awk '{ print $1,$2,$3,$4 }')]"
		temp="/tmp/temp.diary"
		cat >$temp <<EOF
$(sed 1q $currentdiary)

$timestamp
$msg

$(tail +3 $currentdiary)
EOF
cat $temp >$currentdiary
	
	;;
	new)

timestamp="[$(date | awk '{ print $1,$2,$3,$4 }')]"
ed $currentdiary >/dev/null <<EOF
3i
$timestamp


.
w
q
EOF
vim $currentdiary

	;;		 
	all) cat $currentdiary; echo '' ;;
	
	*) head -20 $currentdiary; echo '' ;;
esac



