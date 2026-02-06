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

#for i in range(1,8):
subprocess.call('tar -zxf MARS_MAG_gene_kofam.tar.gz', stdout=True, shell=True)
this_kofam = pd.read_csv('MARS_MAG_gene_kofam/kofam.out.txt', comment='#', sep='\t',
                   names = ['hit', 'Gene_ID', 'KO', 'thrshld', 'score', 'E-value', 'KO_definition'])

this_kofam_hit = this_kofam[this_kofam.hit == "*"]

#if i == 1:
 #   kofam_out = this_kofam_hit
#else:
 #   kofam_out = pd.concat([kofam_out, this_kofam_hit], axis=0)

#subprocess.call('rm -r MARS_MAG_gene_kofam', stdout=True, shell=True)

kofam_out = this_kofam_hit
kofam_out = kofam_out.drop(columns='hit')

kofam_out.to_csv('/Users/kuehn4/Downloads/MAG_gene_kofam.tsv', sep='\t', index=False)