alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ....="cd ../../../.."

alias n="nautilus ."
alias e="exit"
alias l="ls"
alias lsa="ls -a"
alias eb="vim ~/.bashrc"
alias sb="source ~/.bashrc"
alias ds="du -sh"
alias compress="tar -czf"
alias offline="unshare -n -r"
alias rand10="head /dev/urandom | tr -dc A-Za-z0-9 | head -c10"
alias noprompt="export PS1=\"$ \""

alias lstop="watch ls"
alias grepf="grep \"^>\""
alias sumcol="paste -s -d + | bc"

function lessf {
	path=$(ls $1 | head -1)
	less $1${path}
}
function lessl {
	path=$(ls $1 | tail -1)
	less $1${path}
}
function tailf {
	path=$(ls $1 | head 1)
	tail $1${path}
}
function taill {
	path=$(ls $1 | tail -1)
	tail $1${path}
}
function tailfl {
	path = $(ls $@ | tail -1)
	tail -f $1${path}
}
function deref {
	cp $1 $1.here
	rm $1
	mv $1.here $1
}
function cdl {
	path=$(ls $@ | tail -1)
	cd ${path}
	pwd
	ls
}
function cdf {
	path=$(ls $@ | head -1)
	cd ${path}
	pwd
	ls
}
function cl {
	cd $1
	ls
}


