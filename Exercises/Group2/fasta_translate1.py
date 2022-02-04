'''
Christine Hwang, chwang14@jhu.edu
Group 2 Exercises

Read a single FASTA file (SHH.fa) into a dictionary object and print out the
dictionary
'''

import sys

def fasta_to_dict():
    ''' Return FASTA read dictionary {descriptor_str: sequence_str} '''
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

def main():
    print(fasta_to_dict())

if __name__ == "__main__": main()
