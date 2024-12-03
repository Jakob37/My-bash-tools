alias b="git branch"
alias bs="git branch; git status"
alias p="git pull"
alias co="git checkout"
alias pm="git pull origin master"
alias pmp="echo 'Pull and push'; git pull; git pull origin master; git push"
alias pdp="echo 'Pull and push (develop)'; git pull; git pull origin develop; git push"
alias s="git status"
alias pu="git push"

alias m="git checkout master"
alias d="git checkout develop"

alias dm="git difftool origin/master"
alias c="git commit -m"
alias a="git add -A ."
alias aa="git add -A :/"
alias aac="git add -A :/; git commit -m"

alias lci="git log --oneline | head -1 | cut -f1 -d\" \""

alias ppgh="git pull; git push github"

function gitpush() {
	local tmpvar2=$(git branch --show-current);
	git push --set-upstream origin ${tmpvar2};
}

function pushall() {
    for remote in $(git remote); do
        git push ${remote}
    done
}

alias gitcleancheck="git branch --merged | grep -v '\*\|master\|main\|develop\|dev'"
alias gitcleando="git branch --merged | grep -v '\*\|master\|main\|develop\|dev' | xargs -n 1 git branch -d"

function gitrenameorigin() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: gitrenameorigin <new name>"
        return 1
    fi

    new_name=$1

    url=$(git remote show origin | grep "Fetch URL" | sed "s/.* URL: //")
    git remote add ${new_name} ${url}
    git fetch github
    git remote remove origin
    echo "Remote renamed to GitHub"
    git remote show
}

function gitpushboth() {
    git push github
    git push hopper
}
alias pushboth="gitpushboth"
alias changelog="git add CHANGELOG.md; git commit -m Changelog"
