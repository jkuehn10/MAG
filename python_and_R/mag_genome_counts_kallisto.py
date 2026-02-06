# -*- coding: utf-8 -*-

import os
import re
import glob
import subprocess
import numpy as np
import pandas as pd

from Bio import SeqIO

os.chdir('/Users/kuehn4/Downloads/')
print(os.getcwd())

wgs_list = [
    os.path.basename(x).replace("MAG_kallisto_", "").replace(".tar.gz", "")
    for x in sorted(glob.glob("MAG_kallisto_*.tar.gz"))
]

for wgs_id in wgs_list:

    subprocess.call('tar -zxf MAG_kallisto_{}.tar.gz'.format(wgs_id), stdout=True, shell=True)

    this_tsv = pd.read_csv('MAG_kallisto_{}/abundance.tsv'.format(wgs_id), sep = '\t', na_values=None)
    this_tsv[['bin_name', 'contig_name']] = this_tsv['target_id'].str.split(pat="|", expand=True)

    this_abundance = this_tsv[['bin_name', 'est_counts', 'tpm']].groupby('bin_name').sum()

    subprocess.call('rm -r MAG_kallisto_{}'.format(wgs_id), stdout=True, shell=True)

    this_abundance.to_csv('/Users/kuehn4/Downloads/MAG_kallisto/{}.abundance.tsv'.format(wgs_id), sep='\t')

# count, merge counts without normalization
for wgs_id in wgs_list:

    this_cov = pd.read_csv('/Users/kuehn4/Downloads/MAG_kallisto/{}.abundance.tsv'.format(wgs_id), sep = '\t', na_values=None)
    sample_id = wgs_id
    this_cov = this_cov[['bin_name', 'est_counts']]
    this_cov.columns = ['Bin_ID', sample_id]
    this_cov = this_cov.set_index('Bin_ID')

    if wgs_id == wgs_list[0]:
        cov_out = this_cov
    else:
        cov_out =  pd.concat([cov_out, this_cov[sample_id]], axis=1)

    cov_out.to_csv('/Users/kuehn4/Downloads/MAG_kallisto_counts.tsv', sep='\t', index=True)

    # cpm, merge counts normalized by library size

wgs_stats = pd.read_csv('WGS_seq_depth.tsv', sep = '\t', na_values=None)
wgs_stats['wgs_id'] = wgs_stats['wgs_id'].astype(str)
wgs_list = [str(x) for x in wgs_list]

for wgs_id in wgs_list:

    seq_depth = wgs_stats[wgs_stats['wgs_id'] == wgs_id]['PE_total'].to_list()[0]

    this_cov = pd.read_csv('/Users/kuehn4/Downloads/MAG_kallisto/{}.abundance.tsv'.format(wgs_id), sep = '\t', na_values=None)
    sample_id = wgs_id
    this_cov = this_cov[['bin_name', 'est_counts']]
    this_cov.columns = ['Bin_ID', sample_id]
    this_cov[sample_id] = this_cov[sample_id]/seq_depth*1000000
    this_cov = this_cov.set_index('Bin_ID')

    if wgs_id == wgs_list[0]:
        cov_out = this_cov
    else:
        cov_out =  pd.concat([cov_out, this_cov[sample_id]], axis=1)

    cov_out.to_csv('/Users/kuehn4/Downloads/MAG_kallisto_cpm.tsv', sep='\t', index=True)

    # tpm
for wgs_id in wgs_list:

    this_cov = pd.read_csv('/Users/kuehn4/Downloads/MAG_kallisto/{}.abundance.tsv'.format(wgs_id), sep = '\t', na_values=None)
   # sample_id = meta_wgs[meta_wgs['wgs_id'] == wgs_id]['sample_id'].to_list()[0] #not reading in meta_wgs bc it is just batch number (2023 vs 2024) and these are all in same batch
    sample_id = wgs_id
    this_cov = this_cov[['bin_name', 'tpm']]
    this_cov.columns = ['Bin_ID', sample_id]
    this_cov = this_cov.set_index('Bin_ID')

    if wgs_id == wgs_list[0]:
        cov_out = this_cov
    else:
        cov_out =  pd.concat([cov_out, this_cov[sample_id]], axis=1)

    cov_out.to_csv('/Users/kuehn4/Downloads/MAG_kallisto_tpm.tsv', sep='\t', index=True)