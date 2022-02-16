# Christine Hwang, chwang14@jh.edu
# p03_p01
# Recognize spam with a support vector machine

library(kernlab)
set.seed(3)
data(spam)

# split into train (80%) and test (20%)
testidx <- which(1:length(spam[,1])%%5 == 0)
spamtrain <- spam[-testidx,]
spamtest <- spam[testidx,]

# train SVM with training set
library(e1071)
model <- svm(type~., data = spamtrain)

# predict testing set with SVM
prediction <- predict(model, spamtest)

# plot ROC curve
library(ROCR)
score <- prediction$posterior[, c("spam")]
actual_class <- spamtest$type == 'spam'
pred <- prediction(score, actual_class)
perf <- performance(pred, "tpr", "fpr")
auc <- performance(pred, "auc")
auc <- unlist(slot(auc, "y.values"))
plot(perf, colorize = TRUE)
legend(0.6, 0.3, c(c(paste('AUC is', auc)), "\n"), border = "white", cex = 1.0, box.col = "white")