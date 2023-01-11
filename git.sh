alias b="git branch"
alias bs="git branch; git status"
alias p="git pull"
alias co="git checkout"
alias pm="git pull origin master"
alias pmp="echo 'Pull and push'; git pull; git pull origin master; git push"
alias s="git status"
alias pu="git push"

alias m="git checkout master"
alias d="git checkout develop"

alias dm="git difftool origin/master"
alias c="git commit -m"
alias a="git add -A ."
alias aa="git add -A :/"
alias aac="git add -A :/; git commit -m"

#get_branch() {
#	git rev-parse --abbrev-ref HEAD;
#}

function gitpush() {
	local tmpvar2=$(git branch --show-current);
	git push --set-upstream origin ${tmpvar2};
}
