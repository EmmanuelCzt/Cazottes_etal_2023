#!/bin/bash

VCF=$1

mkdir table

java -jar /home/emmanuel/software/gatk-4.1.5.0/gatk-package-4.1.5.0-local.jar VariantsToTable \
-V ${VCF} \
--arguments_file argt \
-O table/`basename ${VCF} .vcf`.tab