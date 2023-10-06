alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ....="cd ../../../.."

alias n="nautilus ."
alias e="exit"
alias l="ls"
alias lsa="ls -a"
alias lh="ls -sh"
alias eb="vim ~/.bashrc"
alias sb="source ~/.bashrc"
alias ds="du -sh"
alias compress="tar -czf"
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

function listfiles {
	find $1 -maxdepth 1 -not -type d | sort
}
function listdirs {
	find $1 -maxdepth 1 -type d -not -path '*/.*' | sort
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
	path=$(listfiles $1 | tail -1)
	tail -f $1${path}
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
function cl {
	cd $1
	pwd
	ls
}
function vcfhead {
	grep -v "^##" $1 | head -1
	grep -v "^#" $1 | head -10
}
function zvcfhead {
	zgrep -v "^##" $1 | head -1
	zgrep -v "^#" $1 | head -10
}
function fullpath {
	path=$(realpath $1)
	echo ${path}
}
alias fp=fullpath
function table {
	column -s$'\t' -t $1
}
function tablel {
	table $1 | less -S
}
alias la="ls -a"

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

function vcf_add_chr {
    sed "/^#/! s/^/chr/" $1
}
function vcf_remove_chr {
    sed "/^#/! s/^chr//" $1
}

function vcf_gz_addchr {
    bgzip -d -c $1 | vcf_add_chr | bgzip -c > ${1%.vcf.gz}.chr.vcf.gz
    tabix ${1%.vcf.gz}.chr.vcf.gz
}
function vcf_gz_removechr {
    bgzip -d -c $1 | vcf_remove_chr | bgzip -c > ${1%.vcf.gz}.chr.vcf.gz
    tabix ${1%.vcf.gz}.chr.vcf.gz
}

