#!/bin/bash #use bash specifically, not just any shell

#troubleshooting:
set -euo pipefail #Exit on error, treat Unset variables as errors, fail On any command in pipeline, exit if anything fails
echo "PWD=$(pwd)"
ls -lh #long format, human readable sizes

# unpack pipeline #-x extract files from an archive, -z filter through gzip, -f tells tar the next argument is filename
tar -xzf SPAdes-3.15.5.tar.gz
tar -xzf Prodigal-2.6.3.tar.gz
tar -xzf python-3.8.tar.gz
tar -xzf python-3.8-packages.tar.gz

# verify extraction #-d says show info about the directory itself, not whats inside; this is for troubleshooting
ls -ld SPAdes-3.15.5/bin/spades.py

# set path #export: any child process/later bash created knows where to look for this variable
export PATH=$(pwd)/SPAdes-3.15.5/bin:$PATH #colon means add path instead of replace; prepend so this local version overrides any system version if it exists; adding a new directory before existing ones so don't lose the rest of the system PATH
export PATH=$(pwd)/Prodigal-2.6.3:$PATH
export PATH=$(pwd)/python-3.8/bin:$PATH
export PYTHONPATH=$(pwd)/python-3.8-packages

# transfer trimmed reads
cp /staging/kuehn4/MARS_clean_reads/$1_R1_trimmed_paired_humanDNAremoved.fastq.gz .
cp /staging/kuehn4/MARS_clean_reads/$1_R2_trimmed_paired_humanDNAremoved.fastq.gz .

# uncompress
gunzip $1_R1_trimmed_paired_humanDNAremoved.fastq.gz
gunzip $1_R2_trimmed_paired_humanDNAremoved.fastq.gz

# create output dir 
mkdir assembly_out_$1

# run pipeline #assembling short seq reads into contigs w spades; de novo assembly
python assembly_pipeline.py -F $1_R1_trimmed_paired_humanDNAremoved.fastq -R $1_R2_trimmed_paired_humanDNAremoved.fastq -o assembly_out_$1/ -s $1

# clean some spades_out files #remove all except contigs and scaffolds fasta files
mv assembly_out_$1/spades_out/contigs.fasta .
mv assembly_out_$1/spades_out/scaffolds.fasta .
rm -r assembly_out_$1/spades_out/*
mv contigs.fasta assembly_out_$1/spades_out/
mv scaffolds.fasta assembly_out_$1/spades_out/

# tar output #-c create a new archive, -z compress it w gzip, -f specify its filename (next argument)
tar -czf assembly_out_$1.tar.gz assembly_out_$1

# move output to staging/kuehn4
mv assembly_out_$1.tar.gz /staging/kuehn4/MARS_WGS

# clear other data
rm *.fastq
rm *.tar.gz
