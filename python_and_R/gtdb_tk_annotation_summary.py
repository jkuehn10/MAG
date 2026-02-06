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

mag_gtdbtk_ar = pd.read_csv('/Users/kuehn4/Downloads/MAG_gtdbtk_out/classify/gtdbtk.ar53.summary.tsv', sep = '\t', na_values=None)
mag_gtdbtk_bac = pd.read_csv('/Users/kuehn4/Downloads/MAG_gtdbtk_out/classify/gtdbtk.bac120.summary.tsv', sep = '\t', na_values=None)
mag_gtdbtk = pd.concat([mag_gtdbtk_bac, mag_gtdbtk_ar], axis = 0, ignore_index = True)

mag_gtdbtk_out = pd.DataFrame({'Bin_ID': mag_gtdbtk['user_genome'].to_list()})
mag_gtdbtk_out[['Domain', 'Phylum', 'Class', 'Order', 'Family', 'Genus', 'Species']] = mag_gtdbtk['classification'].str.split(pat=";", expand=True)

mag_gtdbtk_out.to_csv('/Users/kuehn4/Downloads/MAG_gtdbtk_summary.tsv', sep='\t', index=False)