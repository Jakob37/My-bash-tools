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

function listfiles {
	find $1 -maxdepth 1 -not -type d
}

function lessf {
	path=$(listfiles $1 | head -1)
	less $1${path}
}
function lessl {
	path=$(listfiles $1 | tail -1)
	less $1${path}
}
function tailf {
	path=$(listfiles $1 | head -1)
	tail $1${path}
}
function taill {
	path=$(listfiles $1 | tail -1)
	tail $1${path}
}
function tailfl {
	path = $(listfiles $@ | tail -1)
	tail -f $1${path}
}
function deref {
	cp $1 $1.here
	rm $1
	mv $1.here $1
}
function cdl {
	path=$(listfiles $@ | tail -1)
	cd ${path}
	pwd
	ls
}
function cdf {
	path=$(listfiles $@ | head -1)
	cd ${path}
	pwd
	ls
}
function listfiles {
	cd $1
	ls
}
function vcfhead {
	grep -v "^##" | head -1
	grep -v "^#" | head -10
}
