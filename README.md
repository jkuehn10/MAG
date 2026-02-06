## MAG analysis pipeline

This pipeline is Qijun Zhang's use for metagenomic and metatranscriptomic analysis using shotgun sequencing reads.

The quantitative output for microbial phenotype is the MAG (Metagenome-assembled genomes) abundance and microbial transcripts abundance of MAG genes.

This repository was forked by Jessamine Kuehn from the [original repository](https://github.com/qijunz/MAG/tree/master) to add documentation and update scripts. 

## Steps

The input data for this pipeline should be shotgun sequencing reads (fastq format).

### [0] Trim, filter, and concatenate reads

Shotgun sequencing reads vary in length and quality, and individual samples may have been sequenced across multiple flow-cell lanes. 

- First, reads are quality trimmed with a sliding window of 4 bases and a minimum average Phred score of 20 (SLIDINGWINDOW:4:20). Reads shorter than 50 bp after trimming are discarded (MINLEN:50).

- Then, paired reads that pass trimming and filtering are retained as read pairs. For each sample, concatenate reads from different sequencing lanes to generate a single paired-end read set per sample. 

One example for this step on CHTC is shown in `chtc/MARS_WGS_trimmomatic_concatLanes_MAGS.sh`. This script was adapted from Qijun’s script.


### [1] Remove host reads

The shotgun sequencing usually contain host contamination reads, the proportion of host reads vary from sample to sample (e.g., human vs. mouse, diets also impact)

- First, reads are aligned against the mouse genome (mm10/GRCm38) or human genome (GRCh38) using Bowtie2 (`--local`).

- Then, reads that were not aligned to the host genome were identified using samtools (`samtools view -b -f 4 -f 8`). 

One example for this step running on [CHTC](https://chtc.cs.wisc.edu/) is showed in `chtc/WGS_removeHostRead.sh`.


### [2] *de novo* assembly

Assemble short sequencing reads into longer fragment is the central step to generate MAGs. There are many different assemblers that people use. Here is the example using [SPAdes](https://github.com/ablab/spades). 

- First, the clean microbial reads from each sample are assembled into contigs using SPAdes (`metaspades.py -k 21,33,55,77`).

- Then, any contigs short than 500bp are discorded. You can customize this cutoff. 

One example for this step running on [CHTC](https://chtc.cs.wisc.edu/) is showed in `chtc/WGS_assembly.sh`.

### [3] Contigs binning into MAG

The assembled contigs are usually genome fragments, contigs binning can generate bacteria genomes (i.e., MAGs). There are several different binning tools people use, some studies consider using different binning tools and combine MAGs. Here is the example using [MetaBAT2](https://bioconda.github.io/recipes/metabat2/README.html).

- Many binning tools consider contigs abundance as the MAG features. So first step is to map shotgun reads to assembled contigs in each samples. One example running on [CHTC](https://chtc.cs.wisc.edu/) is showed in `chtc/WGS_mapping_contigs.sh`.

- Next, provided the sorted `.bam` file of reads mapping to contigs and the contigs sequence files, MetaBAT2 (default parameters) are used for contigs binning. One example running on [CHTC](https://chtc.cs.wisc.edu/) is showed in `chtc/WGS_binning_metabat2.sh`.

- Third, make a file that only includes the MAGs (.fa files) in each sample. 
Add sample name to bin names so that bins do not overwrite each other when they are combined. An example script is `chtc/WGS_collect_all_MAGs.sh`. 

- Finally, combine all MAG files from all samples into one tarball. An example script is `chtc/WGS_combine_MARS_MAGs.sh`. 


### [4] MAG quality control and dereplication

The output of MetaBat2 are all the bins identified. Because the assembly are performed in single samples, redundant MAGs may exist among different samples.

- To assess MAGs quality, [CheckM](https://github.com/Ecogenomics/CheckM) (`checkm lineage_wf`) is used to estimate genome completeness and contamination for each MAG. The high-quality MAGs are usually defined as "completeness > 90% and contamination < 5%"

- The high-quality MAGs were dereplicated using [dRep](https://github.com/MrOlm/drep) (`-pa 0.9 -sa 0.99`). 

- In each secondary clusters of dRep output, the representative MAGs are chosen by the highest score. The MAG score is defined as (with default parameters from dRep):

>  A\*Completeness - B\*Contamination + C\*(Contamination * (strain_heterogeneity/100)) + D\*log(N50) + E\*log(size) + F\*(centrality - S_ani)

> default: A=1, B=5, C=1, D=0.5, E=0, F=1


The output of this step is the final set of high-quality non-redundant MAGs (completeness > 90%, contamination < 5% and average nucleotide identity (ANI) > 99%). One example for this step running on [CHTC](https://chtc.cs.wisc.edu/) is showed in `chtc/MAG_checkm.sh` and `chtc/MAG_drep.sh`.

After the checkm step but before the drep step, reorganization and filtering is necessary. One way to do this is to transfer MAG_checkm_out (unzipped) and MARS_MAG (unzipped) to the local computer; then run the following python scripts in the python folder, adapted from a script from Qijun: 

- `python_and_R/after_checkm_part1.py` moves data from the .out file to a readable .tsv file.
- `python_and_R/after_checkm_part2.py` filters high quality MAGs with completeness >90% and contamination <5%.
- `python_and_R/after_checkm_part3.py` formats the columns of the table of stats for each MAG in a .tsv file.

Then transfer MARS_MAG_HQ back to the CHTC home directory and zip it. 

After the drep step, move MAG_drep_out (unzipped) to the local computer. 

- In RStudio run the following R script, adapted from the one from Qijun: `python_and_R/MAG_drep_011726.R` to score MAGs and select those with the highest score as representative MAGs (as described with the formula above) to generate a list of non-redundant MAGs. 
- Then run the following python script, adapted from the one from Qijun: `python_and_R/after_drep.py` to create a folder containing .fa files for only the non-redundant MAGs. 

Then transfer that folder, MARS_MAG_NR, back to the CHTC home directory and zip it. 

*Note: these may be large files to transfer to the local computer. Another possibility is to run these python scripts in the CHTC with .sub and .sh files. 

### [5] MAG taxonomy classification

Taxonomic assignments of these 436 MAGs were using the Genome Taxonomy Database Toolkit ([GTDB-Tk](https://github.com/Ecogenomics/GTDBTk)) and the GTDB database. One example running on [CHTC](https://chtc.cs.wisc.edu/) is showed in `chtc/MAG_gtdbtk.sh`. Note: this uses a conda environment, which must be created in the CHTC home directory with conda-forge, bioconda, and gtdbtk version 2.3.2 installed before running this script.

Then transfer MAG_gtdbtk_out to the local computer and run `python_and_R/gtdb_tk_annotation_summary.py`, adapted from Qijun's script, to put the data into a readable .tsv file. This contains taxonomic assignments of MAGs. 


### [6] MAG gene identification and annotation

With full sequence of MAG, genes can be predicted and annotated to different database.

- First, in each MAG, genes (i.e., open reading frames) are predicted using [Prodigal](https://github.com/hyattpd/Prodigal) and annotated using [Prokka](https://github.com/tseemann/prokka), which give the gene categories (e.g., CDS, rRNA, tRNA, tmRNA).
- Then, the predicted genes can be annotated aginist [KEGG](https://www.genome.jp/kegg/), [CAZyme](http://www.cazy.org/) and [pfam](http://pfam.xfam.org/) etc.
- For example, genes can be annotated to KEGG using [hmmer](http://hmmer.org/) and [kofam](https://github.com/takaram/kofam_scan) database.

One example for this step running on [CHTC](https://chtc.cs.wisc.edu/) is showed in `chtc/MAG_prokka.sh` and `chtc/MAG_gene_kofam.sh`.

After MAG_prokka.sh, run `python_and_R/MAG_prokka_annotation.py`, adapted from Qijun's script, which puts gene information from each MAG into one spreadsheet and puts the .faa files for each gene into one folder.

Note: for MAG_gene_kofam.sh, tools are downloaded from https://www.genome.jp/ftp/db/kofam/. In this script, instead of compiling ruby and parallel, these are installed into a conda environment in the CHTC home directory before running this script.

After MAG_gene_kofam.sh, run `python_and_R/KEGG_kofam_annotation_summary.py`, adapted from Qijun's script, which filters to select only KOs that have been confidently assigned and exports the data in a readable .tsv file. This provides KO assignments to genes in MAGs. 


### [7] Estimate MAG and MAG gene abundance

To get quantitative microbial phenotypes, MAG and MAG gene abundances can be estimated by mapping shotgun DNA/RNA reads to MAG/MAG genes. Here is example using pseudo-alignment tool [kallisto](https://github.com/pachterlab/kallisto).

- To estimate MAG abundance, a single kallisto index using all MAG sequences can be generated (`kallisto index`).

- To estimate MAG gene abundance, a single kallisto index using all gene sequences can be generated (`kallisto index`).

- MAG or MAG gene abundance then can be estimated using `kallisto quant`.

One example for this step running on [CHTC](https://chtc.cs.wisc.edu/) is showed in `chtc/MAG_kallisto.sh`.

Before step 7, run `python_and_R/prep_for_kallisto.py`, adapted from Qijun's script, to rename the non-redundant MAG fasta files so that bin/MAG ID is added before contig number in the file name so that kallisto can keep them separate. 

After step 7, run `python_and_R/MAG_genome_counts_kallisto.py`, adapted from Qijun's script, to export the estimated relative abundances in a readable .tsv file, and do cpm and tpm normalization. 

### [8] Build Hidden Markov Models (HMMs) for genes of interest and identify MAGs with these genes

To identify MAGs that are putative producers of propionate and butyrate, genes and their gene IDs required for and specific to pathways for their production were identified from the literature. Well-validated amino acid sequences were acquired from the NCBI database and used to assemble a reference sequences .fasta file, with at least 5 reference sequences per gene. With hmm_012026.py, adapted from Qijun's script, muscle was used to perform multiple sequence alignment and HMMER was used to build Hidden Markov Models (HMMs) from these reference sequences (at least 5 per gene) and search each gene for a match to each HMM. The output .csv file provides information on which MAGs contain the genes involved in each pathway of interest.


## Contact
**Qijun Zhang** (qijun0507@gmail.com)
**Jessamine Kuehn** (jessaminekuehn@gmail.com)