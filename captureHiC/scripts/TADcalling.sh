#!/bin/bash


BED2WIG=("/home/emmanuel/software/bedGraphToBigWig")
CHROM=("/home/emmanuel/Documents/annotations/chrom.sizes/rheMac10chrom.noScaff.sorted.sizes" "/home/emmanuel/Documents/annotations/chrom.sizes/hg38.sorted.noScaff.chrom.sizes" "/home/emmanuel/Documents/annotations/chrom.sizes/panTro6chrom.noScaff.sorted.sizes")
BIN=("20000" "10000" "8000" "7000" "6000" "5000" "4000" "2000" "1000")
INDIR=("cooler/merge")
INFILE=("rhES" "H9" "chiPSC") 

i=0

COOL=("ontarget.XIConly.q23.cool")
OUTDIR=("TAD")

mkdir ${OUTDIR}

while [ $i -lt `echo "${#INFILE[@]}"` ]
do
    j=0
    mkdir ${OUTDIR}/${INFILE[$i]}
    while [ $j -lt `echo "${#BIN[@]}"` ]
    do
        STEP=$((${BIN[$j]}*2))
        MIN=$((${BIN[$j]}*3))
        MAX=$((((${BIN[$j]}*10)+${STEP})))
        
        PREFIX=$(echo ${INFILE[$i]}\_min${MIN}\_max${MAX}\_step${STEP}\_bin${BIN[$j]})
        
        mkdir ${OUTDIR}/${INFILE[$i]}/${BIN[$j]}
        
        hicFindTADs -m ${INDIR}/${INFILE[$i]}/${BIN[$j]}/${INFILE[$i]}.${COOL} \
            --outPrefix ${OUTDIR}/${INFILE[$i]}/${BIN[$j]}/${PREFIX} \
            --minDepth ${MIN} --maxDepth ${MAX} --step ${STEP} --correctForMultipleTesting fdr -p 12
        
        ${BED2WIG} ${OUTDIR}/${INFILE[$i]}/${BIN[$j]}/${PREFIX}_score.bedgraph \
        ${CHROM} \
        ${OUTDIR}/${INFILE[$i]}/${BIN[$j]}/${PREFIX}_score.bw
        
        j=$(($j+1))

    done
    i=$(($i+1))
done
