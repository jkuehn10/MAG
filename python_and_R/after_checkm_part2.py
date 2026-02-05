# -*- coding: utf-8 -*-

import os
import re
import glob
import subprocess
import numpy as np
import pandas as pd
import shutil

from Bio import SeqIO

os.chdir('/Users/kuehn4/Downloads/')
print(os.getcwd())
# filtering MAGs with Completeness > 90% and Contamination < 5%
meta_mag = pd.read_csv('/Users/kuehn4/Downloads/MAG_checkm_summary.tsv', sep = '\t', na_values=None)

mag_ids = meta_mag['Bin_ID'][(meta_mag['Completeness'] > 90) & (meta_mag['Contamination'] < 5)].to_list()

os.makedirs('MARS_MAG_HQ', exist_ok=True)

for mag_id in mag_ids:
    src = f'MARS_MAG/{mag_id}.fa'
    dst = f'MARS_MAG_HQ/{mag_id}.fa'
    shutil.copy(src, dst)

#for mag_id in mag_ids:
 #   subprocess.call('cp MARS_MAG/{}.fa MARS_MAG_HQ/'.format(mag_id), stdout=True, shell=True)