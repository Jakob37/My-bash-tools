
function add_chr_to_bam {

    if [[ $# -ne 1 ]]; then
        echo "Usage: add_chr_to_bam in_bam > out_sam"
        echo "Received number of arguments: $#" 
        exit 1
    fi

    samtools view -h $1 | sed -e '/^@SQ/s/SN\:/SN\:chr/' -e '/^[^@]/s/\t/\tchr/2'| awk -F ' ' '$7=($7=="=" || $7=="*"?$7:sprintf("chr%s",$7))' | tr " " "\t"
}

#function vcf_get {
#    if [[ $# -ne 2 && $# -ne 3 && $# -ne 4 ]]; then
#        echo "Usage: vcf_get <vcf> chr pos [end-pos] OR vcf_get <vcf> chr:pos"
#        return 1
#    fi
#
#    if [[ $# -eq 2 ]]; then
#        chr=${2%:*}
#        pos=${2#*:}
#        tabix $1 ${chr}:${pos}-${pos}
#    fi
#
#    if [[ $# -eq 3 ]]; then
#        tabix $1 "$2:$3-$3"
#    fi
#
#    if [[ $# -eq 4 ]]; then
#        tabix $1 "$2:$3-$4"
#    fi
#}


