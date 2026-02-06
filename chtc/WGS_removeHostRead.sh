#!/bin/bash

# unpack pipeline 
unzip bowtie2-2.3.4-linux-x86_64.zip
tar -xzf samtools-1.19.tar.gz
tar -xzf bedtools2-2.28.0.tar.gz
tar -xzf python-3.8.tar.gz
tar -xzf python-3.8-packages.tar.gz

# set path
export PATH=$(pwd)/bowtie2-2.3.4-linux-x86_64:$PATH
export BT2_HOME=$(pwd)/bowtie2-2.3.4-linux-x86_64
export PATH=$(pwd)/samtools-1.19/bin:$PATH
export PATH=$(pwd)/bedtools2-2.28.0/bin:$PATH
export PATH=$(pwd)/python-3.8/bin:$PATH
export PYTHONPATH=$(pwd)/python-3.8-packages


# transfer trimmed reads and indexed human genome
cp /staging/kuehn4/MARS_WGS/$1_R1_trimmomaticTrimmed_paired.fastq.gz .  
cp /staging/kuehn4/MARS_WGS/$1_R2_trimmomaticTrimmed_paired.fastq.gz . 
cp /staging/kuehn4/PROG_instl/Homo_sapiens_GRCh38_bowtie2_index.tar.gz .

# uncompress
gunzip $1_R1_trimmomaticTrimmed_paired.fastq.gz
gunzip $1_R2_trimmomaticTrimmed_paired.fastq.gz
tar -xzf Homo_sapiens_GRCh38_bowtie2_index.tar.gz

# alignment WGS reads to human genome
bowtie2 -x Homo_sapiens_GRCh38_bowtie2_index/ref \
        -1 $1_R1_trimmomaticTrimmed_paired.fastq \
        -2 $1_R2_trimmomaticTrimmed_paired.fastq \
        -p 4 |
samtools view -bS > $1_humanGenome_align.bam

# get human genome unmapped sam file
samtools view -b -f 4 -f 8 -o $1_humanDNA_unmapped.bam $1_humanGenome_align.bam

# sort unmapped bam file
samtools sort -n $1_humanDNA_unmapped.bam -o $1_humanDNA_unmapped_sorted.bam
rm $1_humanDNA_unmapped.bam

>&2 echo "flagstat of sorted bam file: "
>&2 samtools flagstat $1_humanDNA_unmapped_sorted.bam

# extract unmapped reads from bam file
bamToFastq -i $1_humanDNA_unmapped_sorted.bam \
           -fq $1_R1_trimmed_paired_humanDNAremoved.fastq \
           -fq2 $1_R2_trimmed_paired_humanDNAremoved.fastq

# compress fastq data
gzip -f $1_R1_trimmed_paired_humanDNAremoved.fastq
gzip -f $1_R2_trimmed_paired_humanDNAremoved.fastq

# transfer reconstruct unmapped and mapped reads into gluster
mv $1_R1_trimmed_paired_humanDNAremoved.fastq.gz /staging/kuehn4/MARS_WGS/
mv $1_R2_trimmed_paired_humanDNAremoved.fastq.gz /staging/kuehn4/MARS_WGS/

# clear space
rm *.bam
rm *.fastq
rm *.tar.gz
