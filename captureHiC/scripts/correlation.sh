#!/bin/bash

START=("50000")
END=("2000000")
OUTDIR=("correlation")
RES=("10000" "6000" "5000" "4000")
INDIR=("rhES" "chiPSC" "H9")

i=0

mkdir ${OUTDIR}


while [ $i -lt `echo "${#INDIR[@]}"` ]
mkdir ${OUTDIR}/${INDIR[$i]}
j=0
do
    while [ $j -lt `echo "${#RES[@]}"` ]
    do
        hicCorrelate -m cooler/replicates/${INDIR[$i]}/${RES[$j]}/${INDIR[$i]}_rep1_ontarget.XIConly.q23.cool \
        cooler/replicates/${INDIR[$i]}/${RES[$j]}/${INDIR[$i]}_rep2_ontarget.XIConly.q23.cool \
        --method=pearson --log1p \
        --labels ${INDIR[$i]}_rep1 ${INDIR[$i]}_rep2 \
        --range ${START}:${END} \
        --outFileNameHeatmap ${OUTDIR}/${INDIR[$i]}/${INDIR[$i]}_${START}\_${END}_${RES[$j]}bins_heatmap.svg \
        --outFileNameScatter ${OUTDIR}/${INDIR[$i]}/${INDIR[$i]}_${START}\_${END}_${RES[$j]}bins_scatterplot.svg \
        --plotFileFormat svg

        j=$(($j+1))
    done
    i=$(($i+1))
done