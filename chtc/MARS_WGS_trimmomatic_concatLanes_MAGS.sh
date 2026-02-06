#!/bin/bash

# unpack trimmomatic and java installation
unzip PROG_instl/Trimmomatic-0.39.zip
tar -xzvf jre-8u231-linux-x64.tar.gz

# make sure the script will use your trimmomatic and java installation
# adding Trimmomatic-0.39/ to PATH may not work
export PATH=$(pwd)/Trimmomatic-0.39:$PATH
export JAVA_HOME=$(pwd)/jre1.8.0_231
export PATH=$(pwd)/jre1.8.0_231/bin:$PATH

# all files: R1/R2 in 20240408 L008, 20240411 L002/L003/L004/L005/L006/L007/L008
cp /staging/kuehn4/MARS_WGS_raw/$9_$1_R1_001.fastq.gz .
cp /staging/kuehn4/MARS_WGS_raw/$9_$1_R2_001.fastq.gz .

cp /staging/kuehn4/MARS_WGS_raw/$9_$2_R1_001.fastq.gz .
cp /staging/kuehn4/MARS_WGS_raw/$9_$2_R2_001.fastq.gz .

cp /staging/kuehn4/MARS_WGS_raw/$9_$3_R1_001.fastq.gz .
cp /staging/kuehn4/MARS_WGS_raw/$9_$3_R2_001.fastq.gz .

cp /staging/kuehn4/MARS_WGS_raw/$9_$4_R1_001.fastq.gz .
cp /staging/kuehn4/MARS_WGS_raw/$9_$4_R2_001.fastq.gz .

cp /staging/kuehn4/MARS_WGS_raw/$9_$5_R1_001.fastq.gz .
cp /staging/kuehn4/MARS_WGS_raw/$9_$5_R2_001.fastq.gz .

cp /staging/kuehn4/MARS_WGS_raw/$9_$6_R1_001.fastq.gz .
cp /staging/kuehn4/MARS_WGS_raw/$9_$6_R2_001.fastq.gz .

cp /staging/kuehn4/MARS_WGS_raw/$9_$7_R1_001.fastq.gz .
cp /staging/kuehn4/MARS_WGS_raw/$9_$7_R2_001.fastq.gz .

cp /staging/kuehn4/MARS_WGS_raw/$9_$8_R1_001.fastq.gz .
cp /staging/kuehn4/MARS_WGS_raw/$9_$8_R2_001.fastq.gz .

# unzip raw reads
gzip -d $9_$1_R1_001.fastq.gz
gzip -d $9_$1_R2_001.fastq.gz
gzip -d $9_$2_R1_001.fastq.gz
gzip -d $9_$2_R2_001.fastq.gz
gzip -d $9_$3_R1_001.fastq.gz
gzip -d $9_$3_R2_001.fastq.gz
gzip -d $9_$4_R1_001.fastq.gz
gzip -d $9_$4_R2_001.fastq.gz
gzip -d $9_$5_R1_001.fastq.gz
gzip -d $9_$5_R2_001.fastq.gz
gzip -d $9_$6_R1_001.fastq.gz
gzip -d $9_$6_R2_001.fastq.gz
gzip -d $9_$7_R1_001.fastq.gz
gzip -d $9_$7_R2_001.fastq.gz
gzip -d $9_$8_R1_001.fastq.gz
gzip -d $9_$8_R2_001.fastq.gz

## quality trmming, lane1
java -jar Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 1 \
$9_$1_R1_001.fastq \
$9_$1_R2_001.fastq \
$9_$1_R1_001_trimmomaticTrimmed_paired.fastq \
$9_$1_R1_001_trimmomaticTrimmed_unpaired.fastq \
$9_$1_R2_001_trimmomaticTrimmed_paired.fastq \
$9_$1_R2_001_trimmomaticTrimmed_unpaired.fastq \
SLIDINGWINDOW:4:20 MINLEN:50

## quality trmming, lane2
java -jar Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 1 \
$9_$2_R1_001.fastq \
$9_$2_R2_001.fastq \
$9_$2_R1_001_trimmomaticTrimmed_paired.fastq \
$9_$2_R1_001_trimmomaticTrimmed_unpaired.fastq \
$9_$2_R2_001_trimmomaticTrimmed_paired.fastq \
$9_$2_R2_001_trimmomaticTrimmed_unpaired.fastq \
SLIDINGWINDOW:4:20 MINLEN:50

## quality trmming, lane3
java -jar Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 1 \
$9_$3_R1_001.fastq \
$9_$3_R2_001.fastq \
$9_$3_R1_001_trimmomaticTrimmed_paired.fastq \
$9_$3_R1_001_trimmomaticTrimmed_unpaired.fastq \
$9_$3_R2_001_trimmomaticTrimmed_paired.fastq \
$9_$3_R2_001_trimmomaticTrimmed_unpaired.fastq \
SLIDINGWINDOW:4:20 MINLEN:50

## quality trmming, lane4
java -jar Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 1 \
$9_$4_R1_001.fastq \
$9_$4_R2_001.fastq \
$9_$4_R1_001_trimmomaticTrimmed_paired.fastq \
$9_$4_R1_001_trimmomaticTrimmed_unpaired.fastq \
$9_$4_R2_001_trimmomaticTrimmed_paired.fastq \
$9_$4_R2_001_trimmomaticTrimmed_unpaired.fastq \
SLIDINGWINDOW:4:20 MINLEN:50

## quality trmming, lane5
java -jar Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 1 \
$9_$5_R1_001.fastq \
$9_$5_R2_001.fastq \
$9_$5_R1_001_trimmomaticTrimmed_paired.fastq \
$9_$5_R1_001_trimmomaticTrimmed_unpaired.fastq \
$9_$5_R2_001_trimmomaticTrimmed_paired.fastq \
$9_$5_R2_001_trimmomaticTrimmed_unpaired.fastq \
SLIDINGWINDOW:4:20 MINLEN:50

## quality trmming, lane6
java -jar Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 1 \
$9_$6_R1_001.fastq \
$9_$6_R2_001.fastq \
$9_$6_R1_001_trimmomaticTrimmed_paired.fastq \
$9_$6_R1_001_trimmomaticTrimmed_unpaired.fastq \
$9_$6_R2_001_trimmomaticTrimmed_paired.fastq \
$9_$6_R2_001_trimmomaticTrimmed_unpaired.fastq \
SLIDINGWINDOW:4:20 MINLEN:50

## quality trmming, lane7
java -jar Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 1 \
$9_$7_R1_001.fastq \
$9_$7_R2_001.fastq \
$9_$7_R1_001_trimmomaticTrimmed_paired.fastq \
$9_$7_R1_001_trimmomaticTrimmed_unpaired.fastq \
$9_$7_R2_001_trimmomaticTrimmed_paired.fastq \
$9_$7_R2_001_trimmomaticTrimmed_unpaired.fastq \
SLIDINGWINDOW:4:20 MINLEN:50

## quality trmming, lane8
java -jar Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 1 \
$9_$8_R1_001.fastq \
$9_$8_R2_001.fastq \
$9_$8_R1_001_trimmomaticTrimmed_paired.fastq \
$9_$8_R1_001_trimmomaticTrimmed_unpaired.fastq \
$9_$8_R2_001_trimmomaticTrimmed_paired.fastq \
$9_$8_R2_001_trimmomaticTrimmed_unpaired.fastq \
SLIDINGWINDOW:4:20 MINLEN:50

# clean raw seq
rm *001.fastq


# cancatenate lanes, R1 paired
cat $9_$1_R1_001_trimmomaticTrimmed_paired.fastq >> $9_R1_trimmomaticTrimmed_paired.fastq
cat $9_$2_R1_001_trimmomaticTrimmed_paired.fastq >> $9_R1_trimmomaticTrimmed_paired.fastq
cat $9_$3_R1_001_trimmomaticTrimmed_paired.fastq >> $9_R1_trimmomaticTrimmed_paired.fastq
cat $9_$4_R1_001_trimmomaticTrimmed_paired.fastq >> $9_R1_trimmomaticTrimmed_paired.fastq
cat $9_$5_R1_001_trimmomaticTrimmed_paired.fastq >> $9_R1_trimmomaticTrimmed_paired.fastq
cat $9_$6_R1_001_trimmomaticTrimmed_paired.fastq >> $9_R1_trimmomaticTrimmed_paired.fastq
cat $9_$7_R1_001_trimmomaticTrimmed_paired.fastq >> $9_R1_trimmomaticTrimmed_paired.fastq
cat $9_$8_R1_001_trimmomaticTrimmed_paired.fastq >> $9_R1_trimmomaticTrimmed_paired.fastq

# cancatenate lanes, R2 paired
cat $9_$1_R2_001_trimmomaticTrimmed_paired.fastq >> $9_R2_trimmomaticTrimmed_paired.fastq
cat $9_$2_R2_001_trimmomaticTrimmed_paired.fastq >> $9_R2_trimmomaticTrimmed_paired.fastq
cat $9_$3_R2_001_trimmomaticTrimmed_paired.fastq >> $9_R2_trimmomaticTrimmed_paired.fastq
cat $9_$4_R2_001_trimmomaticTrimmed_paired.fastq >> $9_R2_trimmomaticTrimmed_paired.fastq
cat $9_$5_R2_001_trimmomaticTrimmed_paired.fastq >> $9_R2_trimmomaticTrimmed_paired.fastq
cat $9_$6_R2_001_trimmomaticTrimmed_paired.fastq >> $9_R2_trimmomaticTrimmed_paired.fastq
cat $9_$7_R2_001_trimmomaticTrimmed_paired.fastq >> $9_R2_trimmomaticTrimmed_paired.fastq
cat $9_$8_R2_001_trimmomaticTrimmed_paired.fastq >> $9_R2_trimmomaticTrimmed_paired.fastq

# cancatenate lanes, R1 unpaired
cat $9_$1_R1_001_trimmomaticTrimmed_unpaired.fastq >> $9_R1_trimmomaticTrimmed_unpaired.fastq
cat $9_$2_R1_001_trimmomaticTrimmed_unpaired.fastq >> $9_R1_trimmomaticTrimmed_unpaired.fastq
cat $9_$3_R1_001_trimmomaticTrimmed_unpaired.fastq >> $9_R1_trimmomaticTrimmed_unpaired.fastq
cat $9_$4_R1_001_trimmomaticTrimmed_unpaired.fastq >> $9_R1_trimmomaticTrimmed_unpaired.fastq
cat $9_$5_R1_001_trimmomaticTrimmed_unpaired.fastq >> $9_R1_trimmomaticTrimmed_unpaired.fastq
cat $9_$6_R1_001_trimmomaticTrimmed_unpaired.fastq >> $9_R1_trimmomaticTrimmed_unpaired.fastq
cat $9_$7_R1_001_trimmomaticTrimmed_unpaired.fastq >> $9_R1_trimmomaticTrimmed_unpaired.fastq
cat $9_$8_R1_001_trimmomaticTrimmed_unpaired.fastq >> $9_R1_trimmomaticTrimmed_unpaired.fastq

# cancatenate lanes, R2 unpaired
cat $9_$1_R2_001_trimmomaticTrimmed_unpaired.fastq >> $9_R2_trimmomaticTrimmed_unpaired.fastq
cat $9_$2_R2_001_trimmomaticTrimmed_unpaired.fastq >> $9_R2_trimmomaticTrimmed_unpaired.fastq
cat $9_$3_R2_001_trimmomaticTrimmed_unpaired.fastq >> $9_R2_trimmomaticTrimmed_unpaired.fastq
cat $9_$4_R2_001_trimmomaticTrimmed_unpaired.fastq >> $9_R2_trimmomaticTrimmed_unpaired.fastq
cat $9_$5_R2_001_trimmomaticTrimmed_unpaired.fastq >> $9_R2_trimmomaticTrimmed_unpaired.fastq
cat $9_$6_R2_001_trimmomaticTrimmed_unpaired.fastq >> $9_R2_trimmomaticTrimmed_unpaired.fastq
cat $9_$7_R2_001_trimmomaticTrimmed_unpaired.fastq >> $9_R2_trimmomaticTrimmed_unpaired.fastq
cat $9_$8_R2_001_trimmomaticTrimmed_unpaired.fastq >> $9_R2_trimmomaticTrimmed_unpaired.fastq

# compress output
gzip -f $9_R1_trimmomaticTrimmed_paired.fastq
gzip -f $9_R2_trimmomaticTrimmed_paired.fastq
gzip -f $9_R1_trimmomaticTrimmed_unpaired.fastq
gzip -f $9_R2_trimmomaticTrimmed_unpaired.fastq

# transfer trimmed seq back to gluster
mv $9_R1_trimmomaticTrimmed_paired.fastq.gz /staging/kuehn4/MARS_WGS/
mv $9_R2_trimmomaticTrimmed_paired.fastq.gz /staging/kuehn4/MARS_WGS/
mv $9_R1_trimmomaticTrimmed_unpaired.fastq.gz /staging/kuehn4/MARS_WGS/
mv $9_R2_trimmomaticTrimmed_unpaired.fastq.gz /staging/kuehn4/MARS_WGS/

# clean individual seq data
rm *.fastq
