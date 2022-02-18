# Christine Hwang, chwang14@jh.edu
# p03_p01
# Recognize spam with a support vector machine

library(kernlab)
set.seed(3)
data(spam)

# split into train (80%) and test (20%)
testidx <- which(1:length(spam[, 1]) %% 5 == 0)
spamtrain <- spam[-testidx,]
spamtest <- spam[testidx,]

# train SVM with training set
library(e1071)
model <- svm(type~., data = spamtrain)

# predict testing set with SVM
prediction <- predict(model, spamtest)

# plot ROC curve
library(ROCR)
pred <- prediction(as.numeric(prediction), as.numeric(spamtest$type))
perf <- performance(pred, "tpr", "fpr")
svmauc <- performance(pred, "auc")
svmauc <- unlist(slot(svmauc, "y.values"))
plot(perf, colorize = TRUE)
legend(0.6, 0.3, c(c(paste('AUC is', format(round(svmauc, 4), nsmall = 4))), "\n"), border = "white", cex = 1.0, box.col = "white")

# repeat using 10-fold cross validation
folds <- function(x, n) split(x, sort(rep(1:n, len = length(x))))
split <- folds(spam, 10)