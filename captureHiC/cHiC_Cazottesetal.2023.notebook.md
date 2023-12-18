```bash
HICPRO=("/home/emmanuel/software/HiCPro/HiC-Pro/bin/")
REFGENOME=("/home/emmanuel/Documents/Genomes/")
OUTPATH=("/home/emmanuel/Documents/capture_HiC/hicpro/")
```


```bash
#DpnII bed files for chimp
${HICPRO}utils/digest_genome.py -r ^GATC \
-o ${OUTPATH}pantro6_dpnII_hicpro.bed \
${REFGENOME}panTro6/panTro6.fa

#DpnII bed files for macaques
${HICPRO}utils/digest_genome.py -r ^GATC \
-o ${OUTPATH}rhemac10_dpnII_hicpro.bed \
${REFGENOME}rhemac10/rhemac10.fa

#DpnII bed files for humans
${HICPRO}utils/digest_genome.py -r ^GATC \
-o ${OUTPATH}hg38_dpnII_hicpro.bed \
${REFGENOME}hg38/hg38.fa
```

# WT cell lines


```bash
${HICPRO}HiC-Pro -i raw_chiPSC -o hicpro_chiPSC -c HiCpro_config/config_chiPSC.txt
${HICPRO}HiC-Pro -i raw_h9 -o hicpro_H9 -c HiCpro_config/config_h9.txt
${HICPRO}HiC-Pro -i raw_rhES -o hicpro_rhES -c HiCpro_config/config_rhES.txt
```


```bash
multiqc -o hicpro_chiPSC hicpro_chiPSC/hic_results/stats/chiPSC
```


```bash
multiqc -o hicpro_H9 hicpro_H9/hic_results/stats/H9
```


```bash
multiqc -o hicpro_rhES hicpro_rhES/hic_results/stats/
```

## Extracting captured XIC regions

ICE assumes homogenous coverage but capture dramatically enrich for one region only, so remove signal outside of the capture range and reads mapping quality >= 23.

Human : chrX:72413462-75413462

rhesus : chrX:69479389-72479389

chimp : chrX:67854356-70854356


```bash
#Human
INDIR=("hicpro_H9/hic_results/data")
INFILE=("H9_rep")
START=72413462
END=75413462

awk -v s=${START} -v e=${END} '$2=="chrX" && $5=="chrX" && $3>=s && $3<=e && $6>=s && $6<=e && $10>=23 && $11>=23 {print $0}' \
${INDIR}/${INFILE}1/${INFILE}1_ontarget.allValidPairs > \
${INDIR}/${INFILE}1/${INFILE}1_ontarget.XIConly.allValidPairs

awk -v s=${START} -v e=${END} '$2=="chrX" && $5=="chrX" && $3>=s && $3<=e && $6>=s && $6<=e && $10>=23 && $11>=23 {print $0}' \
${INDIR}/${INFILE}2/${INFILE}2_ontarget.allValidPairs > \
${INDIR}/${INFILE}2/${INFILE}2_ontarget.XIConly.allValidPairs
```


```bash
#chimp
INDIR=("hicpro_chiPSC/hic_results/data")
INFILE=("chiPSC_rep")
START=67854356
END=70854356

awk -v s=${START} -v e=${END} '$2=="chrX" && $5=="chrX" && $3>=s && $3<=e && $6>=s && $6<=e && $10>=23 && $11>=23 {print $0}' \
${INDIR}/${INFILE}1/${INFILE}1_ontarget.allValidPairs > \
${INDIR}/${INFILE}1/${INFILE}1_ontarget.XIConly.allValidPairs

awk -v s=${START} -v e=${END} '$2=="chrX" && $5=="chrX" && $3>=s && $3<=e && $6>=s && $6<=e && $10>=23 && $11>=23 {print $0}' \
${INDIR}/${INFILE}2/${INFILE}2_ontarget.allValidPairs > \
${INDIR}/${INFILE}2/${INFILE}2_ontarget.XIConly.allValidPairs
```


```bash
#rhesus
INDIR=("hicpro_rhES/hic_results/data")
INFILE=("rhES_rep")
START=69479389
END=72479389

awk -v s=${START} -v e=${END} '$2=="chrX" && $5=="chrX" && $3>=s && $3<=e && $6>=s && $6<=e && $10>=23 && $11>=23 {print $0}' \
${INDIR}/${INFILE}1/${INFILE}1_ontarget.allValidPairs > \
${INDIR}/${INFILE}1/${INFILE}1_ontarget.XIConly.allValidPairs

awk -v s=${START} -v e=${END} '$2=="chrX" && $5=="chrX" && $3>=s && $3<=e && $6>=s && $6<=e && $10>=23 && $11>=23 {print $0}' \
${INDIR}/${INFILE}2/${INFILE}2_ontarget.allValidPairs > \
${INDIR}/${INFILE}2/${INFILE}2_ontarget.XIConly.allValidPairs
```

## Make unbalanced cooler files

Unbalanced cooler files for correlation and later balance/zoomify. Script more or less from NC hicpro2glass. sh


```bash
chmod +x scripts/hicpro2cooler.sh
```


```bash
./scripts/hicpro2cooler.sh
```

## Correlation

on the raw bin counts


```bash
chmod +x scripts/correlation.sh
```


```bash
./scripts/correlation.sh
```

### H9 

**5 kb bins**

![h9pic](correlation/H9/H9_50000_2000000_5000bins_scatterplot.png)

**10 kb bins**

![h9pic](correlation/H9/H9_50000_2000000_10000bins_scatterplot.png)

### chiPSC 

**5 kb bins**

![chiPSCpic](correlation/chiPSC/chiPSC_50000_2000000_5000bins_scatterplot.png)

**10 kb bins**

![chiPSCpic](correlation/chiPSC/chiPSC_50000_2000000_10000bins_scatterplot.png)

### rhES 

**5 kb bins**

![rhESpic](correlation/rhES/rhES_50000_2000000_5000bins_scatterplot.png)

**10 kb bins**

![rhESpic](correlation/rhES/rhES_50000_2000000_10000bins_scatterplot.png)


this is gud


```bash
#balancing
RES=("6000" "10000")
OUTDIR=("contact_maps")
INDIR=("cooler")
INFILE=("chiPSC" "H9" "rhES")
COORD=("chrX:67854356-70854356" "chrX:72413462-75413462" "chrX:69479389-72479389")

mkdir ${INDIR}/${OUTDIR}

i=0

while [ $i -lt `echo "${#INFILE[@]}"` ]
do
    mkdir ${INDIR}/${OUTDIR}/${INFILE[$i]}
    j=0
    while [ $j -lt `echo "${#RES[@]}"` ]
    do
        cooler balance -p 12 \
        cooler/${INFILE[$i]}/${RES[$j]}/${INFILE[$i]}_rep1_ontarget.XIConly.cool
        cooler balance -p 12 \
        cooler/${INFILE[$i]}/${RES[$j]}/${INFILE[$i]}_rep2_ontarget.XIConly.cool
        cooler show -b --out  ${INDIR}/${OUTDIR}/${INFILE[$i]}/${RES[$j]}_rep1_iced.svg \
        --dpi 200 cooler/${INFILE[$i]}/${RES[$j]}/${INFILE[$i]}_rep1_ontarget.XIConly.cool \
        ${COORD[$i]}
        cooler show -b --out  ${INDIR}/${OUTDIR}/${INFILE[$i]}/${RES[$j]}_rep2_iced.svg \
        --dpi 200 cooler/${INFILE[$i]}/${RES[$j]}/${INFILE[$i]}_rep2_ontarget.XIConly.cool \
        ${COORD[$i]}
        j=$(($j+1))
    done
    i=$(($i+1))
done
```

## Merge and balance replicates


```bash
#merge folder
mkdir hicpro_H9/hic_results/data/merge
mkdir hicpro_chiPSC/hic_results/data/merge
mkdir hicpro_rhES/hic_results/data/merge
```


```bash
#H9
cat hicpro_H9/hic_results/data/H9_rep1/H9_rep1_ontarget.XIConly.allValidPairs \
hicpro_H9/hic_results/data/H9_rep2/H9_rep2_ontarget.XIConly.allValidPairs | sort -k3,3n \
> hicpro_H9/hic_results/data/merge/H9_ontarget.XIConly.allValidPairs
```


```bash
cat hicpro_chiPSC/hic_results/data/chiPSC_rep1/chiPSC_rep1_ontarget.XIConly.allValidPairs \
hicpro_chiPSC/hic_results/data/chiPSC_rep2/chiPSC_rep2_ontarget.XIConly.allValidPairs | sort -k3,3n \
> hicpro_chiPSC/hic_results/data/merge/chiPSC_ontarget.XIConly.allValidPairs
```


```bash
cat hicpro_rhES/hic_results/data/rhES_rep1/rhES_rep1_ontarget.XIConly.allValidPairs \
hicpro_rhES/hic_results/data/rhES_rep2/rhES_rep2_ontarget.XIConly.allValidPairs | sort -k3,3n \
> hicpro_rhES/hic_results/data/merge/rhES_ontarget.XIConly.allValidPairs
```


```bash
#balancing
PAIRS2COOL=("/home/emmanuel/software/HiCPro/HiC-Pro/bin/utils/allValidPairs2cooler.sh")
CHROM=("/home/emmanuel/Documents/annotations/chrom.sizes/panTro6chrom.sizes" "/home/emmanuel/Documents/annotations/chrom.sizes/hg38.chrom.sizes" "/home/emmanuel/Documents/annotations/chrom.sizes/rheMac10chrom.sizes")
RES=("2000" "6000" "10000")
OUTDIR=("cooler/merge")
INDIR=("hicpro_chiPSC/hic_results/data/merge" "hicpro_H9/hic_results/data/merge" "hicpro_rhES/hic_results/data/merge")
INFILE=("chiPSC" "H9" "rhES")

i=0

mkdir ${OUTDIR}


while [ $i -lt `echo "${#INFILE[@]}"` ]
do
	j=0
	mkdir ${OUTDIR}/${INFILE[$i]}
	while [ $j -lt `echo "${#RES[@]}"` ]
	do
    	mkdir ${OUTDIR}/${INFILE[$i]}/${RES[$j]}
    	${PAIRS2COOL} -i ${INDIR[$i]}/${INFILE[$i]}_ontarget.XIConly.allValidPairs \
    	-c ${CHROM[$i]} -r ${RES[$j]} -p 12 -n -o ${OUTDIR}/${INFILE[$i]}/${RES[$j]}
    	j=$(($j+1))
	done
	i=$(($i+1))
done

```


```bash
#balancing
RES=("2000" "6000" "10000")
OUTDIR=("contact_maps")
INDIR=("cooler/merge")
INFILE=("chiPSC" "H9" "rhES")
COORD=("chrX:67854356-70854356" "chrX:72413462-75413462" "chrX:69479389-72479389")

mkdir ${INDIR}/${OUTDIR}

i=0

while [ $i -lt `echo "${#INFILE[@]}"` ]
do
    mkdir ${INDIR}/${OUTDIR}/${INFILE[$i]}
    j=0
    while [ $j -lt `echo "${#RES[@]}"` ]
    do
        cooler balance -p 12 \
        ${INDIR}/${INFILE[$i]}/${RES[$j]}/${INFILE[$i]}_ontarget.XIConly.cool
        cooler show -b --out  ${INDIR}/${OUTDIR}/${INFILE[$i]}/${RES[$j]}_iced.svg \
        --dpi 200 ${INDIR}/${INFILE[$i]}/${RES[$j]}/${INFILE[$i]}_ontarget.XIConly.cool \
        ${COORD[$i]}
        j=$(($j+1))
    done
    i=$(($i+1))
done
```

**Res**

- chiPSC : 1000 to 10000 ok - 2-5k is best
- H9 : 2000-10000 ok - 2-5 kb is best
- rhES : 6kb-10kb is best

Get matrices with 3,4, for H9 and chiPSC and 6,7,8,9 kb bins res for rhesus

## TAD calling


```bash
chmod +x scripts/TADcalling.sh
./scripts/TADcalling.sh
```

## Viewpoints


```bash
chmod +x scripts/viewpoints.sh
./scripts/viewpoints.sh
```

# Capture HiC : rhES del HERVK


```bash
${HICPRO}/bin/HiC-Pro -i raw_delHERVK -o hicpro_delHERVK -c HiCpro_config/config_rhES_delHERVK.txt
```


```bash
multiqc -o hicpro_delHERVK/stats/E9.9 hicpro_delHERVK/hic_results/stats/rhES_E9.9
```

## Capture Region only & q23 alignements

For ice normalization a,d high quality alignements


```bash
#rhesus
INDIR=("hicpro_delHERVK/hic_results/data")
INFILE=("rhES_")
START=69479389
END=72479389

awk -v s=${START} -v e=${END} '$2=="chrX" && $5=="chrX" && $3>=s && $3<=e && $6>=s && $6<=e {print $0}' \
${INDIR}/${INFILE}E9.9/${INFILE}E9.9_ontarget.allValidPairs > \
${INDIR}/${INFILE}E9.9/${INFILE}E9.9_ontarget.XIConly.allValidPairs
```


```bash

```


```bash
##E9.9
awk -v OFS="\t" '$10>=23 && $11>=23 {print $0}' \
hicpro_delHERVK/hic_results/data/rhES_E9.9/rhES_E9.9_ontarget.XIConly.allValidPairs \
> hicpro_delHERVK/hic_results/data/rhES_E9.9/rhES_E9.9_ontarget.XIConly.q23.allValidPairs
```


```bash
#balancing
PAIRS2COOL=("/home/emmanuel/software/HiCPro/HiC-Pro/bin/utils/allValidPairs2cooler.sh")
CHROM=("/home/emmanuel/Documents/annotations/chrom.sizes/rheMac10chrom.sizes")
RES=("2000" "6000" "10000")
OUTDIR=("cooler/merge")
INDIR=("hicpro_rhES/hic_results/data/merge")
INFILE=("rhES")

i=0

mkdir ${OUTDIR}


while [ $i -lt `echo "${#INFILE[@]}"` ]
do
	j=0
	mkdir ${OUTDIR}/${INFILE[$i]}
	while [ $j -lt `echo "${#RES[@]}"` ]
	do
    	mkdir ${OUTDIR}/${INFILE[$i]}/${RES[$j]}
    	${PAIRS2COOL} -i ${INDIR[$i]}/${INFILE[$i]}_ontarget.XIConly.allValidPairs \
    	-c ${CHROM[$i]} -r ${RES[$j]} -p 12 -n -o ${OUTDIR}/${INFILE[$i]}/${RES[$j]}
    	j=$(($j+1))
	done
	i=$(($i+1))
done
```

## TAD calling


```bash
./scripts/TADcalling.sh
```

## Viewpoint


```bash
./scripts/viewpoints.sh
```
