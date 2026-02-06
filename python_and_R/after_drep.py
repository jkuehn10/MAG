# -*- coding: utf-8 -*-

#generating NR (non redundant) MAGs
import os
import re
import glob
import subprocess
import numpy as np
import pandas as pd

from Bio import SeqIO

os.chdir('/Users/kuehn4/Downloads/')
print(os.getcwd())

#meta_mag = pd.read_csv('/Users/kuehn4/Downloads/result/MAG_drep_winner.tsv', sep = '\t', na_values=None)
#mag_nr_id = meta_mag['Bin_ID'].to_list()

#for mag_id in mag_nr_id:
#    subprocess.call('cp MARS_MAG/{}.fa MARS_MAG_NR/'.format(mag_id), stdout=True, shell=True)
#^this code doesn't work bc windows/python can't recognize cp (a shell command); use the below code from chatgpt instead
#import os
import shutil
#import pandas as pd

meta_mag = pd.read_csv(
    '/Users/kuehn4/Downloads/result/MAG_drep_winner.tsv',
    sep='\t'
)

mag_nr_id = meta_mag['Bin_ID'].to_list()

os.makedirs('MARS_MAG_NR', exist_ok=True)

for mag_id in mag_nr_id:
    src = f'MARS_MAG/{mag_id}.fa'
    dst = f'MARS_MAG_NR/{mag_id}.fa'

    if os.path.exists(src):
        shutil.copy(src, dst)
    else:
        print(f'Missing file: {src}')