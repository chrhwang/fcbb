# Christine Hwang, chwang14@jh.edu
# p03_p2
# Recognize class with a support vector machine

library(kernlab)
library(ROCR)
library(e1071)
set.seed(3)

# import text file
data <- read.delim("p03_Kato_P53_mutants_200.txt")

# repeat using 10-fold cross validation
folds <- function(x, n) split(x, sort(rep(1:n, len = length(x))))
split <- folds(data, 3)

id = names(data)
pred_lst = vector(mode = "list", length = 3)
gt_lst = vector(mode = "list", length = 3)
auc_list = vector(mode = "list", length = 3)

for (i in 1:3) {
    test = as.data.frame(split[i])
    names(test) =  id
    train = 0 # initialize train
    
    order = 1
    for (j in 1:3) {
    	if(!(j == i)){
		    train_tmp = as.data.frame(split[j])
		    names(train_tmp) = id
		    if (order == 1) {
		        order = 0
		        train = train_tmp
		    } else {
		      train = rbind(train, train_tmp)
		    }
		}
    }

    # predict testing set with SVM
    model <- svm(CLASS~., data = train, kernel = "radial", probability = TRUE)
    prediction <- predict(model, test, probability = TRUE)
    
  	# plot ROC curve
    pred_prob <- attr(prediction, 'probabilities')[, "D"]
    pred_comb <- prediction(pred_prob, test$CLASS == 'D')
    perf <- performance(pred_comb, "tpr", "fpr")
    svmauc <- performance(pred_comb, "auc")
    svmauc <- unlist(slot(svmauc, "y.values"))

    pred_lst[[i]] <- pred_prob
    gt_lst[[i]] <- test$CLASS == 'D'
    auc_list[i] <- svmauc
    
}


svmpred <- prediction(pred_lst, gt_lst)
svmperf <- performance(svmpred, "tpr", "fpr")
plot(svmperf,col = "grey82", lty = 3)
plot(svmperf, lwd = 3, avg = "vertical", spread.estimate = "boxplot", add = T)
legend(0.6, 0.3, c(c(paste('Average AUC is', format(round(mean(unlist(auc_list)), 4), nsmall = 4))), "\n"), border = "white", cex = 1.0, box.col = "white")