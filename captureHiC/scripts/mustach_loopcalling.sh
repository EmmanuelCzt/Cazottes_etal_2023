#!/bin/bash

BIN=("1000" "2000" "3000" "4000" "5000" "6000" "7000" "8000" "9000" "10000" "20000" "50000")
INDIR=("cooler/")
INFILE=("H9" "rhES" "chiPSC")
#REP=("rep1" "rep2")
COOL=("ontarget.XIConly.q23.cool")
OUTDIR=("loopcalling")

j=0


mkdir ${OUTDIR}


while [ $j -lt `echo "${#INFILE[@]}"` ]
do
   mkdir ${OUTDIR}/${INFILE[$j]}
   i=0
   while  [ $i -lt `echo "${#BIN[@]}"` ]
   do
      PREFIX=$(echo ${INFILE[$j]}\_bin${BIN[$i]})

        
      mkdir ${OUTDIR}/${INFILE[$j]}/${BIN[$i]}

      mustache -f ${INDIR}/${INFILE[$j]}/${BIN[$i]}/${INFILE[$j]}\_${COOL} \
      -ch chrX -r ${BIN[$i]} -pt 0.05 -st 0.88 -p 6 \
      -o ${OUTDIR}/${INFILE[$j]}/${BIN[$i]}/${PREFIX}.tsv

      awk -v OFS="\t" -v a=${INFILE[$j]} '{print $1,$2,$3,$4,$5,$6,a,$7,"+","+"}' \
      ${OUTDIR}/${INFILE[$j]}/${BIN[$i]}/${PREFIX}.tsv | \
      tail -n +2 \
      > ${OUTDIR}/${INFILE[$j]}/${BIN[$i]}/${PREFIX}.bedpe
      i=$(($i+1))
  done

  j=$(($j+1))
done
        




