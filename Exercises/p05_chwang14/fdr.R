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
# Print the number of discoveries at fdr ≤ 0.05 to output.



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

# organize into ascending order by pvalue
data <- data[order(data$pvalue),]

# add qvalue and write to output file
sink(opt$output) # prepare to write to output file
cat("index \t pvalue \t qvalue \n") # header
count = 0 # to keep track of number of discoveries

for (i in 1:nrow(data)) { # for each row
  row <- data[i,] # get row data
  qv = row$pvalue * nrow(data) / i # qvalue
  cat(data[i,]$index, "\t")
  cat(round(data[i,]$pvalue, 6), "\t")
  cat(round(qv, 6), "\n")
  if (qv <= 0.05) {
  count <- count + 1
  }
}
sink()

# print number of discoveries
print(paste0("The number of discoveries is: ", count))
