
function add_chr_to_bam {

    if [[ $# -ne 1 ]]; then
        echo "Usage: add_chr_to_bam in_bam > out_sam"
        echo "Received number of arguments: $#" 
        exit 1
    fi

    samtools view -h $1 | sed -e '/^@SQ/s/SN\:/SN\:chr/' -e '/^[^@]/s/\t/\tchr/2'| awk -F ' ' '$7=($7=="=" || $7=="*"?$7:sprintf("chr%s",$7))' | tr " " "\t"
}

