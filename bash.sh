alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ....="cd ../../../.."

alias n="nautilus ."
alias e="exit"

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
