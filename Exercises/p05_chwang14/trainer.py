'''
Christine Hwang, chwang14@jhu.edu
P05: Exercise 1

This program works to find exonic splicing enhancer (ESE) binding site
sequences in human mRNA. A training set of sequences, which are trusted ESEs,
will be used to train a zero-order Markov chain model. This program will write
its trained model to disk in a tab-delimited format.
'''

import sys
import pysam
import argparse

def readFiles():
    '''
    This function uses parsers to read the command line. Parser -f refers to
    training txt file, while parser -o refers to output txt file. The training
    txt file is read for input, while the output txt file is prepared for
    writing the program output.

    Parameters
    ------------
    None

    Output
    ------------
    Returns input_c, output_file
        input_c (str list): stores lines of training txt file
        output_file (str): name of output file
    '''

    # add parsers -f and -o for reading file names
    parser = argparse.ArgumentParser()
    parser.add_argument('-f', type = str, required = True)
    parser.add_argument('-o', type = str, required = True)

    # get parsers
    args = parser.parse_args()

    # read in file names
    train_file = args.f
    output_file = args.o

    # read ESE training set
    with open(train_file) as f:
        input_c = f.readlines()
    f.close()

    return input_c, output_file

def writeOutput(output_file, a_list, c_list, g_list, t_list, total_c):
    '''
    This function takes in an output file name, lists of 'A,' 'C,' 'G,' 'T'
    occurrence counts by base, and the total count of sequences to write to the
    output file the trained zero-order Markov chain model.

    Parameters
    ------------
    output_file (str): name of output file
    a_list (int list): list of 'A' occurrence count by base
    c_list (int list): list of 'C' occurrence count by base
    g_list (int list): list of 'G' occurrence count by base
    t_list (int list): list of 'T' occurrence count by base
    total_c (int): total count of sequences in training set

    Output
    ------------
    Writes to output file trained zero-order Markov chain model
    '''

    dict = {'A': a_list, 'C': c_list, 'G': g_list, 'T': t_list}
    with open(output_file, 'w') as f:
        f.write("Position")
        for i in range(len(a_list)):
            f.write('\t' + str(i))
        for base in ['A', 'C', 'G', 'T']:
            f.write('\n' + base)
            for i in dict[base]:
                f.write('\t' + str(i) + '/' + str(total_c))

    f.close()

def main():
    # read files
    input_c, output_file = readFiles()

    # train zero-order Markov chain model
    total_c = 0 # for denominator, total count
    a_list = [0 for i in range(len(input_c[0]) - 1)] # to keep track of A bases
    c_list = [0 for i in range(len(input_c[0]) - 1)] # to keep track of C bases
    g_list = [0 for i in range(len(input_c[0]) - 1)] # to keep track of G bases
    t_list = [0 for i in range(len(input_c[0]) - 1)] # to keep track of T bases

    for line in input_c:
        total_c += 1
        c_index = 0 # to keep track of index in line
        for c in line: # go through each base
            if c == 'A':
                a_list[c_index] += 1
            elif c == 'C':
                c_list[c_index] += 1
            elif c == 'G':
                g_list[c_index] += 1
            elif c == 'T':
                t_list[c_index] += 1
            c_index += 1

    # report to output_file
    writeOutput(output_file, a_list, c_list, g_list, t_list, total_c)

if __name__ == '__main__':
    main()
