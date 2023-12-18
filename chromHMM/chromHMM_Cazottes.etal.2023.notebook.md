# ChromHMM

TLDR : ChromHMM runned on bam files with H3K27Ac, H3K4me1, H3K4me3 and chromatin accessibility and 5 states for prediction.


```bash
CHROMHMM=("java -mx4000M -jar /home/emmanuel/software/ChromHMM/ChromHMM.jar")
```


```bash
BINFOLDER=("rhes/binarized_active")
MODELFOLDER=("rhes/model_active")

mkdir ${BINFOLDER}
${CHROMHMM} BinarizeBam -paired /home/emmanuel/Documents/annotations/chrom.sizes/rheMac10chrom.noScaff.sorted.sizes \
rhes_mapping rhes/rhes_chrom.file.active.txt ${BINFOLDER}


mkdir ${MODELFOLDER}

${CHROMHMM} LearnModel -p 12 ${BINFOLDER} ${MODELFOLDER} 5 rheMac10
```
