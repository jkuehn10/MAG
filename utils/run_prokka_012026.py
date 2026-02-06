# -*- coding: utf-8 -*-

# Purpose: Give a directory of bins fasta files, run prokka for each bin
#


import os
import re
import argparse
import subprocess
import pandas as pd


def run_command(command_string, stdout_path = None):
    # checks if a command ran properly. If it didn't, then print an error message then quit
    print('run_kraken2.py, run_command: ' + command_string)
    if stdout_path:
        f = open(stdout_path, 'w')
        exit_code = subprocess.call(command_string, stdout=f, shell=True)
        f.close()
    else:
        exit_code = subprocess.call(command_string, shell=True)

    if exit_code != 0:
        print('run_kraken2.py: Error, the command:')
        print(command_string)
        print('failed, with exit code ' + str(exit_code))
        exit(1)


def run_prokka(bin_dir, bin_id, num_processors=4, out_dir = None):

    run_command('prokka --cpus {} --outdir {}/{} --prefix {} {}/{}.fa'.format(num_processors, out_dir, bin_id, bin_id, bin_dir, bin_id))


def main(args):

    bin_dir = args.bin_dir
    out_dir = args.output_dir

    core = args.processors

    # check if the output dir exists
    if not os.path.isdir(out_dir):
        os.makedirs(out_dir)

    # go through all bin fasta files in bin directory
   # bin_files = [f for f in os.listdir(bin_dir) if re.match('.*fa$', f)]
    bin_files = [f for f in os.listdir(bin_dir) if f.endswith('.fa')]

    for bin_file in sorted(bin_files):
        #bin_id = bin_file.split('/')[-1].split('.')[0]
        bin_id = os.path.splitext(bin_file)[0]
        print(bin_id)

        run_prokka(bin_dir, bin_id, core, out_dir)



if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)

    parser.add_argument('-b', '--bin_dir',
                        help='Directory path for all bins, each bin is a fasta file',
                        type=str,
                        default='')
    parser.add_argument('-p', '--processors',
                        help='Number of CPU',
                        type=int,
                        default=1)
    parser.add_argument('-o', '--output_dir',
                        help='Kraken2 output directory',
                        type=str,
                        default='')

    args = parser.parse_args()

    main(args)