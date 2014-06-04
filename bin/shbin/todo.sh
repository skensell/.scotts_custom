#!/bin/bash

usage="usage:
	todo
		shows the TODO list of the current project, i.e. cat ~/notes/current.todo.txt
	todo create project
		creates the TODO list for a new project
	todo edit [project]
		opens up vim to edit the current TODO or a specific project's TODO
	todo set project
		symlinks ~/notes/project.todo.txt to the current TODO list at ~/notes/current.todo.txt
	todo add some memo
		appends \\nsome memo\\n to the current TODO list
"
die(){ echo "${usage}" >&2; exit 1; }

currenttodo="$HOME/notes/current.todo.txt"

cmd=$1; shift
projectname=$1; shift

projtodo="$HOME/notes/${projectname}.todo.txt"

case $cmd in
	-h) die ;;
	create)
		[ -f $projtodo ] && { echo $projtodo exists already >&2; exit 1; }
		echo "TODO for $projectname
" >$projtodo
	;;
	edit)
		[ -z $projectname ] && vim $currenttodo && exit 0
		vim $projtodo
	;;
	set) 
		[ -z $projectname ] && die
		[ -f $projtodo ] || die
		ln -s -f $projtodo $currenttodo
	;;
	add)
		msg="$projectname $*"
		[ -z "$msg" ] && die
		
		echo "
$msg" >>$currenttodo
	;;		 
	*) cat $currenttodo ;;
esac



