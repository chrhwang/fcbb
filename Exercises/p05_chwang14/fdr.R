# Christine Hwang, chwang14@jhu.edu
# p05: Exercise 2
#
# Implement the Benjamini-Hochberg (BH) procedure for multiple
# hypothesis testing correction.
#
# Do the following:
# 1. Read in the data frame with raw p-values.
# 2. Apply BH correction to each row (experiment) in data frame.
# 3. Store the resulting data frame as a tab-delimited file 
# (with header information) in pvalues.corrected.tsv.
# This file should be formatted like the input file with an additional
# column labeled as qvalue, where a qvalue is pvalue*m/i.
# Note that pvalues in the output file should be sorted in ascending order.



library('getopt')
library('data.table')

# get options, using the spec
# read the options from the default: commandArgs(TRUE)
spec = matrix(c(
'input', 'i', 1, "character",
'output' , 'o', 1, "character"
), byrow = TRUE, ncol = 4)
opt = getopt(spec)

# read in input tsv file
data <- as.data.frame(fread(opt$input))