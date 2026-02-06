#!/bin/bash

#source ~/.bashrc
#conda activate kofam   # <-- or whatever env has ruby + parallel + other tools

#echo "Ruby version:"
#ruby --version
#echo "Parallel version:"
#parallel --version

# unpack pipeline 
#tar -xzf hmmer-3.4.tar.gz
#tar -xzf kofam_scan-1.3.0.tar.gz

#mkdir ruby
#mkdir parallel

# set path
#export PATH=$(pwd)/hmmer-3.4/bin:$PATH
#export PATH=$(pwd)/kofam_scan-1.3.0:$PATH
#export PATH=$(pwd)/ruby/bin:$PATH
#export PATH=$(pwd)/parallel/bin:$PATH
#export PATH

#transfer conda env file
cp /staging/kuehn4/MARS_WGS/kofam.tar.gz . #copy pre-built kofam conda environment (with GTDB-Tk installed) from staging

#define env
ENVNAME=kofam
ENVDIR=$ENVNAME

export PATH
mkdir $ENVDIR
tar -xzf $ENVNAME.tar.gz -C $ENVDIR #capital c bc placeholder to repr name above
. $ENVDIR/bin/activate

# transfer kofam db
cp /staging/kuehn4/MARS_WGS/kofam_20250930/profiles.tar.gz .
cp /staging/kuehn4/MARS_WGS/kofam_20250930/ko_list.gz .

gunzip ko_list.gz
tar -xzf profiles.tar.gz


# install and compile Ruby
#>&2 echo "downloading ruby from website...."
#wget https://cache.ruby-lang.org/pub/ruby/2.7/ruby-2.7.0.tar.gz

#>&2 echo "unpacking ruby source code..."
#tar -xzvf ruby-2.7.0.tar.gz
#cd ruby-2.7.0

#>&2 echo "compiling ruby source code (configure)..."
#./configure --prefix=$(pwd)/../ruby/

#>&2 echo "compiling ruby source code (make)..."
#make

#>&2 echo "compiling ruby source code (make install)..."
#make install
#cd ..

# install and compile parallel
#>&2 echo "downloading parallel from website...."
#wget https://ftp.gnu.org/gnu/parallel/parallel-20231122.tar.bz2

#>&2 echo "unpacking parallel source code..."
#tar -xvjf parallel-20231122.tar.bz2
#cd parallel-20231122

#>&2 echo "compiling parallel source code (configure)..."
#./configure --prefix=$(pwd)/../parallel/

#>&2 echo "compiling parallel source code (make)..."
#make

#>&2 echo "compiling parallel source code (make install)..."
#make install
#cd ..


# transfer metagenes
cp /staging/kuehn4/MARS_WGS/MARS_MAG_genes.faa .

mkdir MARS_MAG_gene_kofam

# run kofam
exec_annotation -o MARS_MAG_gene_kofam/kofam.out.txt --profile profiles/ --ko-list ko_list --format detail-tsv --cpu=4 MARS_MAG_genes.faa

# move output back to staging
tar -czf MARS_MAG_gene_kofam.tar.gz MARS_MAG_gene_kofam
mv MARS_MAG_gene_kofam.tar.gz /staging/kuehn4/MARS_WGS/

# clear dir
rm *.faa
rm *.tar.gz
rm *.tar.bz2
rm ko_list
