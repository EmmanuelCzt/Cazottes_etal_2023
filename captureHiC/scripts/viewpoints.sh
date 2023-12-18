#!/bin/bash

BED2WIG=("/home/emmanuel/software/bedGraphToBigWig")
CHROM=("/home/emmanuel/Documents/annotations/chrom.sizes/rheMac10chrom.noScaff.sorted.sizes" "/home/emmanuel/Documents/annotations/chrom.sizes/hg38.sorted.noScaff.chrom.sizes")
BIN=("10000" "8000" "6000" "4000" "2000")
INDIR=("cooler/merge")
INFILE=("rhES" "H9") 



REFPOINT=("viewpoints/bed/rhemac10.ens98.xicRNA.GnID.TSS.noScaff.plusminus250.XIC.bed" "viewpoints/bed/gencode.v39.annotation.TSS.GnName.plusminus250.XIC.bed")
RANGE=3000000
OUTDIR=("viewpoints")

i=0

COOL=("ontarget.XIConly.q23.cool")

mkdir ${OUTDIR}


while [ $i -lt `echo "${#INFILE[@]}"` ]
do
    j=0
    mkdir ${OUTDIR}/${INFILE[$i]}
    while [ $j -lt `echo "${#BIN[@]}"` ]
    do
        
        PREFIX=$(echo ${INFILE[$i]}\_bin${BIN[$j]})
        
        mkdir ${OUTDIR}/${INFILE[$i]}/${BIN[$j]}

        #Compute background model
		mkdir ${OUTDIR}/${INFILE[$i]}/${BIN[$j]}/bg_model/

		chicViewpointBackgroundModel -m ${INDIR}/${INFILE[$i]}/${BIN[$j]}/${INFILE[$i]}.${COOL} \
		--fixateRange ${RANGE} -t 12 \
		-rp ${REFPOINT[$i]} -o ${OUTDIR}/${INFILE[$i]}/${BIN[$j]}/bg_model/bg_model.txt
        
		#make viewpoint
		SUBRANGE=$( expr ${RANGE} / 2 )

		chicViewpoint -m ${INDIR}/${INFILE[$i]}/${BIN[$j]}/${INFILE[$i]}.${COOL} \
		--averageContactBin 2 --range ${SUBRANGE} ${SUBRANGE} \
		-rp ${REFPOINT[$i]} -bmf ${OUTDIR}/${INFILE[$i]}/${BIN[$j]}/bg_model/bg_model.txt \
		--outputFolder ${OUTDIR}/${INFILE[$i]}/${BIN[$j]}/viewpoint/ \
		--fixateRange ${RANGE} --threads 12

		##bedGraph filter for non significant interactions
		mkdir ${OUTDIR}/${INFILE[$i]}/${BIN[$j]}/bedgraph

		for k in `ls ${OUTDIR}/${INFILE[$i]}/${BIN[$j]}/viewpoint/*.txt`
		do
			awk -v OFS="\t" '$8<0.05 {print $1,$2,$3,$7}' $k > \
			${OUTDIR}/${INFILE[$i]}/${BIN[$j]}/bedgraph/`basename $k .txt`.bedGraph


			${BED2WIG} ${OUTDIR}/${INFILE[$i]}/${BIN[$j]}/bedgraph/`basename $k .txt`.bedGraph \
        	${CHROM[$i]} \
        	${OUTDIR}/${INFILE[$i]}/${BIN[$j]}/`basename $k .txt`.bigwig

		done
        
        j=$(($j+1))

    done
    i=$(($i+1))
done