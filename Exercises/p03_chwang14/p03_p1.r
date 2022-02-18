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
model <- svm(type~., data = spamtrain, probabiity = TRUE)

# predict testing set with SVM
prediction <- predict(model, spamtest, type = 'raw')

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

pred_lst = vector(mode="list",length = 10)
gt_lst = vector(mode="list",length = 10)

for (i in 1:10) {
    test = as.data.frame(split[i])
    names(test) =  names(spamtest)
    train = 0 # initialize train
    
    order = 1
    for (j in 1:10) {
    	if(!(j==i)){
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
    # apply SVM
    model <- svm(type~., train)
    prediction <- predict(model,test)
    
  
    pred <- prediction(as.numeric(prediction),as.numeric(test$type))
    pred <- pred@predictions
    gt <- list(as.numeric(test$type))

    pred_lst[i] <- pred
    gt_lst[i] <- gt
    
	}


	pred <- prediction(pred_lst, gt_lst)
	perf <- performance(pred,"tpr","fpr")
	plot(perf,col = "grey82",lty = 3)
	plot(perf, lwd = 3,avg = "vertical", spread.estimate = "boxplot",add = T)