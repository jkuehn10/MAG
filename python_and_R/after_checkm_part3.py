# -*- coding: utf-8 -*-

# MAG stats and genes
import os
import re
import glob
import subprocess
import numpy as np
import pandas as pd

from Bio import SeqIO

os.chdir('/Users/kuehn4/Downloads/')
print(os.getcwd())

#subprocess runs a Linux shell command from inside python. Here we extract the MAG_checkm_out file, move the bins and stats into new folders
#for i in range(1,34):
#subprocess.call('tar -zxf MAG_checkm_out.tar.gz', stdout=True, shell=True)

#subprocess.call('mv MAG_checkm_out/bins/*_bin[0-9]* bins/', stdout=True, shell=True)

#subprocess.call('mv MAG_checkm_out/storage/bin_stats.analyze.tsv bin_stats/bin_stats.analyze.tsv', stdout=True, shell=True)

#subprocess.call('rm -r MAG_checkm_out', stdout=True, shell=True)
#^did this part manually in my Downloads folder
#here we read the stats file into a pandas data frame w 2 columns - bin id and the dictionary (all the columns in a single cell of the table). Second line expands the dictionary into its columns, w contamination and completeness etc one row per MAG
#for i in range(1,34):

bin_stats = pd.read_csv('bin_stats/bin_stats.analyze.tsv', sep = '\t', names=['Bin_ID', 'stats'], converters={'stats': eval})
bin_stats_concat = pd.concat([bin_stats['Bin_ID'], bin_stats['stats'].apply(pd.Series)], axis=1)

    #this would repeat and concatenate for multiple checkm batches
   # if i == 1:
    #    bin_stats_out = bin_stats_concat
   # else:
    #    bin_stats_out = pd.concat([bin_stats_out, bin_stats_concat], axis=0)

bin_stats_concat.to_csv('/Users/kuehn4/Downloads/MAG_checkm_bin_stats.tsv', sep='\t', index=False)