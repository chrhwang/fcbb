'''
Christine Hwang, chwang14@jhu.edu
P04

This program does the following:
    1. Iterate over the positions in normal.bam and cancer.bam files
    2. At each position, read in the pileup from normal.bam and cancer.bam
    3. If coverage is less than 20 in either file, skip position and report to
    standard output "Insufficient coverage at position XXX"
    4. Otherwise, compute the likelihood of each of the ten possible diploid
    genotypes {AA, CC, GG, TT, AC, AG, AT, CG, CT, GT} at position in normal
    pileup (set e parameter to 0.1)
    5. Identify genotype G that maximizes the likelihood
    6. If the (log) likelihood Log(P(D|G)) < -50, skip position and report to
    standard out "Position XXX has ambiguous genotype"
    7. Using the pileup from cancer.bam at same position, compute the (log)
    likelihood of the bases in the cancer at that position, Log(P(D_tumor|G))
    8. If Log(P(D_tumor|G)) < -75, print statement to standard output that you
    have detected a candidate somatic mutation at that position: "Position XXX
    has a candidate somatic mutation (Log-likelihood = YYY)"
'''

import pysam
import argparse

def readFiles(n_file, c_file):
    normal = pysam.AlignmentFile(n_file, "rb")
    cancer = pysam.AlignmentFile(c_file, "rb")

    iter_n = normal.fetch("seq1", 10, 20)
    iter_c = normal.fetch("seq2", 10, 20)

    for n in iter_n:
        print(str(n))

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-n', type=str, required=True)
    parser.add_argument('-c', type=str, required=True)

    args = parser.parse_args()

    normal_file = args.n
    cancer_file = args.c

    readFiles(normal_file, cancer_file)
