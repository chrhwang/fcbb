'''
Christine Hwang, chwang14@jhu.edu
Group 2 Exercises

Translate a multi-gene FASTA file (genes.fa) and print in FASTA format
'''

import sys

def parse_fasta():
    '''
    Parse reads from a FASTA file
    '''
    dict = {} # {descriptor_str: sequence_str}

    line = sys.stdin.readline() # should be a descriptor_str
    desc_str = line.split('>')[1].split('\n')[0]
    dict[desc_str] = ''

    seq_str = '' # string to collect sequence
    line = sys.stdin.readline() # should be a sequence_str

    while line != "": # till end of file
        if (line[0] == '>'):
            desc_str = line.split('>')[1].split('\n')[0]
            dict[desc_str] = ''
        else:
            dict[desc_str] += line.split('\n')[0]  # sequence_str
        line = sys.stdin.readline()
    
    return dict

def codon_table():
    '''
    Create dictionary of codon table
    '''
    codont = {}
    with open('codon_table_hard.txt', 'r') as f:
        line = f.readline()
        while line != "": # till end of file
            for codon in line.split('\n')[0].split('\t')[2].split(','):
                codont[codon] = line.split('\n')[0].split('\t')[1]
            line = f.readline()
    return codont

if __name__ == "__main__":
    dict = parse_fasta() # make dictionary of {descriptor_str: sequence_str}
    codont = codon_table() # make dictionary of codon table
    err = 0 # to mark exception existence
    codonexc = [] # to keep track of codon exception
    codonexc_count = 0 # to keep track of last codon exception

    for key, value in dict.items():
        print(">" + key)

        if len(value) % 3 != 0: # extra nucleotides at end should not be translated
            endval = len(value) - (len(value) % 3)
            err = 1
        else:
            endval = len(value)
        
        for i in range(0, endval, 3): # for all codons
            if value[i:i + 3] not in codont.keys():
                print('', end = '')
                codonexc.append(value[i:i + 3])
            else:
                print(codont[value[i:i + 3]], end = '')
        print()
        
        if err == 1:
            print("Exception:", len(value) % 3,"nucloetide(s) at end of sequence not translated", file = sys.stderr)
        err = 0

        for i in range(codonexc_count, len(codonexc)):
            print("Exception: Invalid codon with", codonexc[i])
            codonexc_count += 1