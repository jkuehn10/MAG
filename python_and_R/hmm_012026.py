# -*- coding: utf-8 -*-

import os
import re
import glob
import urllib
import subprocess
import pandas as pd
import numpy as np

from io import StringIO

from Bio import SeqIO
from Bio import Entrez
from Bio import AlignIO
from Bio.Align.Applications import MuscleCommandline

"""### Build HMM using gene from Reichardt et al."""

os.chdir('/mnt/c/Users/kuehn4/Downloads/') #added mnt/c bc in ubuntu

gene_list = ['mutB', 'epi', 'mmdA', 'pduP', 'pduCDE',
             'thl', 'bhbd', 'cro', 'but']

#muscle_exe = r"C:\Users\kuehn4\Downloads\muscle.exe"

for gene in gene_list:
    # mulyiple alignment via MUSCLE
    #subprocess.call('muscle3.8.31_i86darwin64 -in ref/{}.fasta \
    subprocess.call('muscle3.8.31_i86win32 -in ref/{}.fasta \
                                            -out ref/{}.afa'.format(gene, gene), stdout=True, shell=True)

    # convert to stockholm format
    hmm_scfa = SeqIO.parse('ref/{}.afa'.format(gene), 'fasta')
    SeqIO.write(hmm_scfa, 'ref/{}.sto'.format(gene), 'stockholm')

    # build hmm profile
    subprocess.call('hmmbuild ref/{}.hmm \
                            ref/{}.sto'.format(gene, gene), stdout=True, shell=True)

# run HMM for propionate

for gene in gene_list:

    hmm_file = 'ref/{}.hmm'.format(gene)
    out_file = 'result/{}.hmm.out'.format(gene)

    # BLASTp
    subprocess.call('hmmsearch --tblout {} {} /mnt/c/Users/kuehn4/Downloads/MARS_MAG_genes.faa'.format(out_file, hmm_file), stdout=True, shell=True)

# concatenate HMM results into single file
hmm_merge = pd.DataFrame()

for gene in gene_list:
    hmm_out_file = 'result/{}.hmm.out'.format(gene)

    # test if no HMM hit, thus hmm out file contains only comment lines
    dummy_pd = pd.read_csv(hmm_out_file, sep='\t', header=None)

    if dummy_pd.shape[0] > 13:
        hmm_out = pd.read_csv(hmm_out_file, delim_whitespace=True, comment='#', header=None, usecols=range(18))

        hmm_out.columns = ['tname', 'tacc', 'qname', 'qacc',
                           'full_evalue', 'full_score', 'full_bias',
                           'domain_evalue', 'domain_score', 'domain_bias',
                           'exp', 'reg', 'clu', 'ov', 'env', 'dom', 'rep', 'inc']

        # add new column to store genome (GCF ID) info
        hmm_out['ref_gene'] = gene

        if hmm_merge.shape[0] == 0:
            hmm_merge = hmm_out
        else:
            hmm_merge = pd.concat([hmm_merge, hmm_out], axis=0)

hmm_merge.to_csv('hmm_out_scfa.csv', sep=',', index=False)