#!/bin/bash

# unpack pipeline 
tar -xzf python-3.8.tar.gz
tar -xzf python-3.8-packages.tar.gz

# set path
export PATH=$(pwd)/python-3.8/bin:$PATH
export PYTHONPATH=$(pwd)/python-3.8-packages


# transfer MAG files
cp /staging/kuehn4/MARS_WGS/MARS_MAG_NR.tar.gz .
tar -zxf MARS_MAG_NR.tar.gz


mkdir MAG_prokka_out

# run Prokka
python run_prokka_012026.py -b MARS_MAG_NR -o MAG_prokka_out -p 4


# move output to staging/kuehn4
tar -czf MAG_prokka_out.tar.gz MAG_prokka_out
mv MAG_prokka_out.tar.gz /staging/kuehn4/MARS_WGS

# clear other data
rm *.tar.gz
