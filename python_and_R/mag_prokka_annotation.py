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

mag_list = [os.path.splitext(os.path.basename(x))[0] for x in sorted(glob.glob('/Users/kuehn4/Downloads/MARS_MAG_NR/*.fa'))]
# tsv
for mag_id in mag_list:

    this_tsv = pd.read_csv('/Users/kuehn4/Downloads/MAG_prokka_out/{}/{}.tsv'.format(mag_id, mag_id), sep = '\t', na_values=None)

    this_tsv['Bin_ID'] = mag_id

    if mag_id == mag_list[0]:
        tsv_out = this_tsv
    else:
        tsv_out =  pd.concat([tsv_out, this_tsv], axis=0)

tsv_out.to_csv('/Users/kuehn4/Downloads/result/MAG_prokka_gene.tsv', sep='\t', index=False)
# faa
all_faa = []

for mag_id in mag_list:

    this_faa = SeqIO.parse('/Users/kuehn4/Downloads/MAG_prokka_out/{}/{}.faa'.format(mag_id, mag_id), 'fasta')

    for this_gene in this_faa:
        all_faa.append(this_gene)

SeqIO.write(all_faa, '/Users/kuehn4/Downloads/MARS_MAG_genes.faa', 'fasta')
# split ~500,000 genes to each fa file
# ref: https://biopython.org/wiki/Split_large_file

def batch_iterator(iterator, batch_size):
    """Returns lists of length batch_size.

    This can be used on any iterator, for example to batch up
    SeqRecord objects from Bio.SeqIO.parse(...), or to batch
    Alignment objects from Bio.Align.parse(...), or simply
    lines from a file handle.

    This is a generator function, and it returns lists of the
    entries from the supplied iterator.  Each list will have
    batch_size entries, although the final list may be shorter.
    """
    batch = []
    for entry in iterator:
        batch.append(entry)
        if len(batch) == batch_size:
            yield batch
            batch = []
    if batch:
        yield batch


record_iter = SeqIO.parse('/Users/kuehn4/Downloads/MARS_MAG_genes.faa', 'fasta')

#for i, batch in enumerate(batch_iterator(record_iter, 500000)):

#filename = '/Users/kuehn4/Downloads/MARS_MAG_genes.faa'
#with open(filename, 'w') as handle:
#    count = SeqIO.write(batch, handle, 'fasta')
#print('Wrote {} records to {}'.format(count, filename))


batch = next(batch_iterator(record_iter, 500000))

out_file = '/Users/kuehn4/Downloads/MARS_MAG_genes.faa'
with open(out_file, 'w') as handle:
    count = SeqIO.write(batch, handle, 'fasta')

print(f'Wrote {count} records to {out_file}')