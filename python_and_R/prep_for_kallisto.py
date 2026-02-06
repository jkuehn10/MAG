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

mag_list = [os.path.splitext(os.path.basename(x))[0] for x in sorted(glob.glob('MARS_MAG_NR/*.fa'))]

mag_rename = []

for mag_id in mag_list:

    mag_file = 'MARS_MAG_NR/{}.fa'.format(mag_id)
    mag_seqs = SeqIO.parse(mag_file, 'fasta')

    for mag_seq in mag_seqs:
        mag_seq.id = mag_id + '|' + mag_seq.id
        mag_rename = mag_rename + [mag_seq]

SeqIO.write(mag_rename, '/Users/kuehn4/Downloads/MARS_MAG_NR_renamed.fasta', 'fasta')