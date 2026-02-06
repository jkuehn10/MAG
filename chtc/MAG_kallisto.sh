#!/bin/bash

# unpack pipeline 
tar -xzf kallisto-v0.50.1.tar.gz
tar -xzf python-3.8.tar.gz
tar -xzf python-3.8-packages.tar.gz

# set path
export PATH=$(pwd)/kallisto-v0.50.1/bin:$PATH
export PATH=$(pwd)/python-3.8/bin:$PATH
export PYTHONPATH=$(pwd)/python-3.8-packages

# transfer and unpack reads
cp /staging/kuehn4/MARS_clean_reads/$1_R1_trimmed_paired_humanDNAremoved.fastq.gz .
cp /staging/kuehn4/MARS_clean_reads/$1_R2_trimmed_paired_humanDNAremoved.fastq.gz .


# transfer HQ MAG fa files
cp /staging/kuehn4/MARS_WGS/MARS_MAG_NR_renamed.fasta .

# run mag_mapping_kallisto.py
mkdir MAG_kallisto_$1

kallisto index -i MARS_MAG_NR_renamed.idx MARS_MAG_NR_renamed.fasta
kallisto quant -i MARS_MAG_NR_renamed.idx -o MAG_kallisto_$1 -t 32 $1_R1_trimmed_paired_humanDNAremoved.fastq.gz $1_R2_trimmed_paired_humanDNAremoved.fastq.gz

# tar output 
tar -czf MAG_kallisto_$1.tar.gz MAG_kallisto_$1

# move output to staging/kuehn4
mv MAG_kallisto_$1.tar.gz /staging/kuehn4/MARS_WGS

# clear other data
rm *.idx
rm *.fasta
rm *.tar.gz
rm *.fastq.gz
