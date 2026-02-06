#!/bin/bash

# transfer conda env file
cp /staging/kuehn4/MARS_WGS/gtdbtk-v2.3.2.tar.gz .

# define env
ENVNAME=gtdbtk-v2.3.2
ENVDIR=$ENVNAME

export PATH
mkdir $ENVDIR
tar -xzf $ENVNAME.tar.gz -C $ENVDIR
. $ENVDIR/bin/activate



# transfer and unpack gtdb-tk database
cp /staging/groups/rey_group_datashare/gtdbtk_r214_data.tar.gz .
tar -xzf gtdbtk_r214_data.tar.gz
rm gtdbtk_r214_data.tar.gz

# set path
export GTDBTK_DATA_PATH=$(pwd)/release214/

# transfer bin fa file
cp /staging/kuehn4/MARS_WGS/MARS_MAG_NR.tar.gz .
tar -zxf MARS_MAG_NR.tar.gz

# create dir of output
mkdir MAG_gtdbtk_out

# running GTDB-Tk
gtdbtk classify_wf --extension fa --genome_dir MARS_MAG_NR/ --out_dir MAG_gtdbtk_out --cpus 4 --skip_ani_screen

# move output to staging/kuehn4
tar -czf MAG_gtdbtk_out.tar.gz MAG_gtdbtk_out
mv MAG_gtdbtk_out.tar.gz /staging/kuehn4/MARS_WGS

# clear other data
rm *.tar.gz
