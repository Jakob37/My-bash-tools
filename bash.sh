alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."
alias ........="cd ../../../../../../.."
alias .........="cd ../../../../../../../.."

alias n="nautilus ."
alias e="exit"
alias l="ls -p"
alias lsa="ls -a"
alias lh="ls -sh"
alias eb="vim ~/.bashrc"
alias sb="source ~/.bashrc"
#alias ds="du -sh"
alias offline="unshare -n -r"
alias rand10="head /dev/urandom | tr -dc A-Za-z0-9 | head -c10"
alias noprompt="export PS1=\"$ \""
function prompt {
	export PS1="$1 $ "
}

alias lstop="watch ls"
alias grepf="grep \"^>\""
alias grepsc="grep -v \"^#\""
alias grepscc="grep -v \"^##\""
alias sumcol="paste -s -d + | bc"
alias h1="head -1"
alias h2="head -2"
alias h3="head -3"
alias h4="head -4"
alias h5="head -5"
alias h10="head -10"
alias tl="tablel"
alias la="ls -a"
alias lesss="less -S"
alias leS="less -S"
alias pingg="ping www.google.com"

function compress {
    if [[ $# -ne 1 ]]; then
        echo "Usage: compress <dir>"
        return 1
    fi
    echo "Running tar -czf ${1%/}.tar.gz $1"
    tar -czf "${1%/}.tar.gz" "$1"
}

function grep1 {
    grep $1 $2 | head -1
}

function zgrep1 {
    zgrep $1 $2 | head -1
}

function listfiles {
	find $1 -maxdepth 1 -not -type d | sort
}
function listdirs {
	find $1 -maxdepth 1 -type d -not -path '*/.*' | sort
}

function lessf {
	path=$(listfiles $1 | head -1)
	less1${path}
}
function lessl {
	path=$(listfiles $1 | tail -1)
	less ${path}
}
function tailf {
	path=$(listfiles $1 | head -1)
	tail ${path}
}
function taill {
	path=$(listfiles $1 | tail -1)
	tail ${path}
}
function tailfl {
	path=$(listfiles $1 | tail -1)
	tail -f ${path}
}
function deref {
	cp $1 $1.here
	rm $1
	mv $1.here $1
}
function cdl {
	path=$(listdirs $1 | tail -1)
	cd ${path}
	pwd
	ls
}
function cdf {
	path=$(listdirs $1 | head -1)
	cd ${path}
	pwd
	ls
}
function vcfheader {
    zgrep "^##" $1
}
function vcfheaderl {
    zgrep "^##" $1 | less
}
function vcfhead {
	zgrep -v "^##" $1 | head -1
	zgrep -v "^#" $1 | head -10
}
function vcfnrec {
    zgrep -v "^#" $1 | wc -l
}
function fullpath {
	path=$(realpath $1)
	echo ${path}
}
alias fp=fullpath
# TBC
#function fpl {
#    in=${1%/}
#    dirpath="${in%/*}"
#    normaldir="$(cd ${dirpath}; pwd)"
#    echo ${normaldir}
#}
function table {
	column -s$'\t' -t $1
}
function cable {
    column -s$',' -t $1
}
function tablel {
	table $1 | less -S
}
function cablel {
    cable $1 | less -S
}
alias cl=cablel

function scheck {
	srun --pty --jobid $1 htop
}
alias vcfpeek="zgrep -m 1 -A1 \"#CHROM\""
function vcfsum {
	nbr_comments=$(zgrep "^##" $1 | wc -l)
	echo " ${nbr_comments} ## rows"
	grep -v "^##" $1 | grep -m 1 "^#"
	zgrep -v "^#" $1 | cut -f1 | uniq -c
}

function zhead {
    zcat $1 | head
}

#function vcf_add_chr {
#    sed "/^#/! s/^/chr/" $1
#}
#function vcf_remove_chr {
#    sed "/^#/! s/^chr//" $1
#}

function vcf_addchr {
    bgzip -d -c $1 | sed "/^#/! s/^/chr/" | bgzip -c > ${1%.vcf.gz}.chr.vcf.gz
    tabix ${1%.vcf.gz}.chr.vcf.gz
}
function vcf_removechr {
    bgzip -d -c $1 | sed "/^#/! s/^chr//" | bgzip -c > ${1%.vcf.gz}.chr.vcf.gz
    tabix ${1%.vcf.gz}.chr.vcf.gz
}

shopt -s direxpand
HISTSIZE=1000000
HISTFILESIZE=1000000

function ds {
    date +%y%m%d
}

function mkdsdir {
    mkdir "$(ds)_${1}"
}
function touchds {
    touch "$(ds)_${1}"
}

function mytree {

    depth=$1

    shopt -s globstar
    for file in **/*
    do
        slash=${file//[^\/]}
        case "${#slash}" in
            0) [[ ${depth} == "" || ${depth} -gt 0 ]] && echo "|-- ${file}";;
            1) [[ ${depth} == "" || ${depth} -gt 1 ]] && echo "|   |--  ${file}";;
            2) [[ ${depth} == "" || ${depth} -gt 2 ]] && echo "|   |   |--  ${file}";;
            3) [[ ${depth} -gt 3 ]] && echo "|   |   |   |--  ${file}";;
            4) [[ ${depth} -gt 4 ]] && echo "|   |   |   |   |--  ${file}";;
        esac
    done
}

function cdn {
    if [[ $# -ne 1 ]]; then
        echo "Usage: cdn <nbr>"
        return 1
    fi

    cd $(ls -d */ | head -n $1 | tail -1)
}
alias cn="cdn"

function cdln {
    if [[ $# -ne 1 ]]; then
        echo "Usage cdln <nbr>"
        return 1
    fi 
    cd $(ls -d */ | tail -n $1 | head -1)
}

function lsg {
    if [[ $# -ne 1 ]]; then
        echo "Usage: lsg <pattern>"
        return 1
    fi

    ls *$1*
}

function targets {
    if [[ -f ~/.targets.txt ]]; then
        echo "----- Current targets -----"
        cat ~/.targets.txt
        echo "---------------------------"
    else
        echo "~/.targets.txt not found" 
    fi
}

alias vimtargets="vim ~/.targets.txt"

echoerr() {
    # https://stackoverflow.com/questions/2990414/echo-that-outputs-to-stderr
    echo "$@" 1>&2
}

function cd_glob() {
    if [[ $# -ne 2 ]]; then
        echo "Usage: cg <partial_folder_name> <fw|rv>"
        return 1
    fi

    local pattern="*$1*"
    local order="$2"
    local dirs=()

    for item in ${pattern}; do
        if [[ -d "${item}" ]]; then
            dirs+=("${item}")
        fi
    done

    if [[ ${#dirs[@]} -eq 0 ]]; then
        echo "No directories found matching '$1'"
        return 1
    fi

    if [[ "${order}" == "rv" ]]; then
        #dirs=( $(echo "${dirs[@]}" | tac -s ' ') )
        dirs=( $(for dir in "${dirs[@]}"; do echo "$dir"; done | tac) )
    elif [[ "${order}" != "fw" ]]; then
        echo "Order should be fw or rv, found: ${order}"
        return 1
    fi

    if [[ ${#dirs[@]} -gt 1 ]]; then

        if [[ "${order}" == "fw" ]]; then
            echo "Multiple directories found, picking the first"
        else
            echo "Multiple directories found, picking the last" 
        fi
        printf "Matches: %s\n" "${dirs[*]}"
    fi

    cd "${dirs[0]}"
}

function cg() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: cg <partial_folder_name>"
        return 1
    fi

    cd_glob $1 "fw"
}

function cgl() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: cgl <partial_folder_name>"
        return 1
    fi

    cd_glob $1 "rv"
}

function match_file() {
    if [[ $# -ne 2 ]]; then
        echo "Usage: match_file <command> <partial_file_name>"
        return 1
    fi
    
    local pattern="*$2*"
    local files=()

    for item in ${pattern}; do
        if [[ -f "${item}" ]]; then
            files+=("${item}")
        fi
    done

    if [[ ${#files[@]} -eq 0 ]]; then
        echo "No files found matching '$2'"
        return 1
    fi

    echo "${files[0]}"
    $1 "${files[0]}"
}

alias lg="match_file less"
alias vg="match_file vim"

fl() {

    echo "FIXME: Not done yet"

    if [ -z "$1" ]; then
        echo "Usage: unresolved_path <file_name>"
        return 1
    fi

    local file_name=$(basename "$1")
    local dir_name=$(dirname "$1")
    local full_dir_path=$(cd "${dir_name}" && pwd)
    local full_path="${full_dir_path}/${file_name}"
    echo "${full_path}"
}

alias cleandirs="find . -maxdepth 1 -type d -empty; rmdir * 2> /dev/null"
t() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: t <sep>"
        return 1
    fi
    column -t -s"${1}"
}

alias gi="grep -i"

venv_activate() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: venv_activate <name>"
        return 1
    fi
    source "/home/jakob/venv/${1}/bin/activate"
}

alias nw="chmod -w"
alias yw="chmod +w"

lsh() {
    ls $1 | head 
}

githubbookmark() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: githubbookmark <raw>"
        return 1
    fi

    raw=$1
    repo_name=$(echo ${raw} | sed "s|.*/||")
    issue_nbr=$(echo ${raw} | sed "s/.*#/#/" | sed "s/ .*//")
    pr_name=$(echo ${raw} | sed "s/ ·.*//")
    echo "${repo_name} (${issue_nbr}): ${pr_name}"
}

alias rsync_nice_20="echo '/usr/bin/nice -n 19 /usr/bin/ionice -c2 -n7 rsync --bwlimit 20000 -avPh'; /usr/bin/nice -n 19 /usr/bin/ionice -c2 -n7 rsync --bwlimit 20000 -avPh"
alias rsync_nice_40="echo '/usr/bin/nice -n 19 /usr/bin/ionice -c2 -n7 rsync --bwlimit 20000 -avPh'; /usr/bin/nice -n 19 /usr/bin/ionice -c2 -n7 rsync --bwlimit 40000 -avPh"
alias rsync_nice="/usr/bin/nice -n 19 /usr/bin/ionice -c2 -n7 rsync"

see() {
    if [[ $# -ne 3 ]]; then
        echo "Usage: see <interval> <times> <command>"
        return 1
    fi
    interval=$1
    times=$2
    command=$3

    count=0
    while [[ $count -lt $times ]]; do
        echo "Execution: ${count} / ${times}"
        ${command}
        sleep ${interval}
        count=$((count + 1))
    done
}

alias first="ls -1 | head -1"

header() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: header <file>"
        return 1
    fi

    head -1 $1 | tr "\t" "\n" | cat -n
}

alias lessh="less --header 1"
th() {
    column -s$'\t' -t $1 | less -S --header 1
}
thl() {
    last_edited=$(ls -t1 | head -1)
    echo "Viewing ${last_edited}"
    column -s$'\t' -t ${last_edited} | less -S --header 1
}

alias 1="cn 1; ls"
alias 2="cn 2; ls"
alias 3="cn 3; ls"
alias 4="cn 4; ls"
alias 5="cn 5; ls"
alias 6="cn 6; ls"
alias 7="cn 7; ls"
alias 8="cn 8; ls"
alias 9="cn 9; ls"
alias 10="cn 10; ls"

function remove_csq() {
    sed "/^#/! s/CSQ=[^;]*;//"
}

function remove_csqh() {
    grep -v "^#" | sed "s/CSQ=[^;]*;//"
}

function grepfb() {
    if [[ $# -ne 2 ]]; then
        echo "Usage: grepfb <pattern_file> <target>"
        return 1
    fi
   
    tmpfile=$(mktemp)
    echo "${tmpfile}"
    cat $1 | while read pattern; do echo "\b${pattern}\b"; done > "${tmpfile}"
    grep -f "${tmpfile}" $2
    #rm "${tmpfile}"
}
