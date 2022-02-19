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
model <- svm(type~., data = spamtrain, kernel = "radial", probability = TRUE)

# predict testing set with SVM
prediction <- predict(model, spamtest, probability = TRUE)

# plot ROC curve
library(ROCR)
pred_prob <- attr(prediction, 'probabilities')[, "spam"]
pred_comb <- prediction(pred_prob, spamtest$type == 'spam')
perf <- performance(pred_comb, "tpr", "fpr")
svmauc <- performance(pred_comb, "auc")
svmauc <- unlist(slot(svmauc, "y.values"))
plot(perf, colorize = TRUE)
legend(0.6, 0.3, c(c(paste('AUC is', format(round(svmauc, 4), nsmall = 4))), "\n"), border = "white", cex = 1.0, box.col = "white")

# repeat using 10-fold cross validation
folds <- function(x, n) split(x, sort(rep(1:n, len = length(x))))
split <- folds(spam, 10)

pred_lst = vector(mode = "list", length = 10)
gt_lst = vector(mode = "list", length = 10)
auc_list = vector(mode = "list", length = 10)

for (i in 1:10) {
    test = as.data.frame(split[i])
    names(test) =  names(spamtest)
    train = 0 # initialize train
    
    order = 1
    for (j in 1:10) {
    	if(!(j == i)){
		    train_tmp = as.data.frame(split[j])
		    names(train_tmp) = names(spamtest)
		    if (order == 1) {
		        order = 0
		        train = train_tmp
		    } else {
		      train = rbind(train, train_tmp)
		    }
		}
    }

    # predict testing set with SVM
    model <- svm(type~., data = train, kernel = "radial", probability = TRUE)
    prediction <- predict(model,test, probability = TRUE)
    
  	# plot ROC curve
    pred_prob <- attr(prediction, 'probabilities')[, "spam"]
    pred_comb <- prediction(pred_prob, test$type == 'spam')
    perf <- performance(pred_comb, "tpr", "fpr")
    svmauc <- performance(pred_comb, "auc")
    svmauc <- unlist(slot(svmauc, "y.values"))

    pred_lst[[i]] <- pred_prob
    gt_lst[[i]] <- test$type == 'spam'
    auc_list[i] <- svmauc
    
}


svmpred <- prediction(pred_lst, gt_lst)
svmperf <- performance(svmpred, "tpr", "fpr")
plot(svmperf,col = "grey82", lty = 3)
plot(svmperf, lwd = 3, avg = "vertical", spread.estimate = "boxplot", add = T)
legend(0.6, 0.3, c(c(paste('Average AUC is', format(round(mean(unlist(auc_list)), 4), nsmall = 4))), "\n"), border = "white", cex = 1.0, box.col = "white")