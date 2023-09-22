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

function lessl {
	path=$(ls $1 | tail -1)
	less $1${path}
}
function taill {
	path=$(ls $1 | tail -1)
	tail $1${path}
}
function tailfl {
	path = $(ls $@ | tail -1)
	tail -f $1${path}
}
