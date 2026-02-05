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
# MAG checkm output table (creating an empty table)
with open('MAG_checkm_summary.tsv', 'w') as out:
    print('Bin_ID\tMarker_lineage\tUID\tgenomes\tmarkers\tmarker_sets\tM0\tM1\tM2\tM3\tM4\tM5more\tCompleteness\tContamination\tStrain_heterogeneity', file = out)

 #   for i in range(1,34):

    with open('MAG_checkm.out', 'r') as checkm_out:
            lines = checkm_out.readlines()
            for line in lines:
                if re.search(r'\d+_bin\.\d+', line.strip()):
                    Bin_Id = line.split()[0]
                    Marker_lineage = line.split()[1]
                    UID = line.split()[2]
                    genomes = line.split()[3]
                    markers = line.split()[4]
                    marker_sets = line.split()[5]
                    M0 = line.split()[6]
                    M1 = line.split()[7]
                    M2 = line.split()[8]
                    M3 = line.split()[9]
                    M4 = line.split()[10]
                    M5more = line.split()[11]
                    Completeness = line.split()[12]
                    Contamination = line.split()[13]
                    Strain_heterogeneity = line.split()[14]

                    print('{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}'.format(Bin_Id,Marker_lineage,UID,genomes,markers,marker_sets,M0,M1,M2,M3,M4,M5more,Completeness,Contamination,Strain_heterogeneity), file = out)
#this prints the data in each row of the out file into the columns in the output table