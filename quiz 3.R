#Question 1
#Load the cell segmentation data from the AppliedPredictiveModeling package using the commands:
library(AppliedPredictiveModeling)
data(segmentationOriginal)
library(caret)
#1. Subset the data to a training set and testing set based on the Case variable in the data set. 
#2. Set the seed to 125 and fit a CART model with the rpart method using all predictor variables and default caret settings. 
#3. In the final model what would be the final model prediction for cases with the following variable values:
# a. TotalIntench2 = 23,000; FiberWidthCh1 = 10; PerimStatusCh1=2 
# b. TotalIntench2 = 50,000; FiberWidthCh1 = 10;VarIntenCh4 = 100 
# c. TotalIntench2 = 57,000; FiberWidthCh1 = 8;VarIntenCh4 = 100 
# d. FiberWidthCh1 = 8;VarIntenCh4 = 100; PerimStatusCh1=2

data <- segmentationOriginal
set.seed(125)
inTrain <- data$Case == "Train"
trainData <- data[inTrain, ]
testData <- data[!inTrain, ]
cartModel <- train(Class ~ ., data=trainData, method="rpart")
cartModel$finalModel #PS / WS / PS / NOT POSSIBLE TO PREDICT

#Question 2
#If K is small in a K-fold cross validation is the bias in the estimate of out-of-sample (test set) accuracy smaller 
#or bigger? If K is small is the variance in the estimate of out-of-sample (test set) accuracy smaller or bigger. 
#Is K large or small in leave one out cross validation?

#The bias is larger and the variance is smaller. Under leave one out cross validation K is equal to the sample size.

#Question 3
#Load the olive oil data using the commands:
library(pgmm)
data(olive)
olive = olive[,-1]
#(NOTE: If you have trouble installing the pgmm package, you can download the olive dataset here: olive_data.zip. 
#After unzipping the archive, you can load the file using the load() function in R.)
#These data contain information on 572 different Italian olive oils from multiple regions in Italy. 
#Fit a classification tree where Area is the outcome variable. 
#Then predict the value of area for the following data frame using the tree command with all defaults
newdata = as.data.frame(t(colMeans(olive)))
#What is the resulting prediction? Is the resulting prediction strange? Why or why not?

treeModel <- train(Area ~ ., data=olive, method="rpart2") #rpart gives an error because of missing data
treeModel
predict(treeModel, newdata) 
#2.783. It is strange because Area should be a qualitative variable - but tree is reporting the average value of 
#Area as a numeric variable in the leaf predicted for newdata	

#Question 4
#Load the South Africa Heart Disease Data and create training and test sets with the following code:
library(ElemStatLearn)
data(SAheart)
set.seed(8484)
train = sample(1:dim(SAheart)[1],size=dim(SAheart)[1]/2,replace=F)
trainSA = SAheart[train,]
testSA = SAheart[-train,]
#Then set the seed to 13234 and fit a logistic regression model (method="glm", be sure to specify family="binomial") 
#with Coronary Heart Disease (chd) as the outcome and age at onset, current alcohol consumption, obesity levels, 
#cumulative tabacco, type-A behavior, and low density lipoprotein cholesterol as predictors. 
#Calculate the misclassification rate for your model using this function and a prediction on the "response" scale:
missClass = function(values,prediction){sum(((prediction > 0.5)*1) != values)/length(values)}
#What is the misclassification rate on the training set? What is the misclassification rate on the test set?

set.seed(13234)
logitModel <- train(chd ~ age + alcohol + obesity + tobacco + 
                      typea + ldl, data=trainSA, method="glm", 
                    family="binomial")
logitModel

missClass <- function(values,prediction){sum(((prediction > 0.5)*1) != values)/length(values)}
predictTrain <- predict(logitModel, trainSA)
predictTest <- predict(logitModel, testSA)
# Training Set Misclassification rate
missClass(trainSA$chd, predictTrain) # 0.2727273
# Test Set Misclassification rate
missClass(testSA$chd, predictTest) # 0.3116883

#Question 5
#Load the vowel.train and vowel.test data sets:
library(ElemStatLearn)
data(vowel.train)
data(vowel.test) 
#Set the variable y to be a factor variable in both the training and test set. Then set the seed to 33833. 
#Fit a random forest predictor relating the factor variable y to the remaining variables. 
#Read about variable importance in random forests here: 
#http://www.stat.berkeley.edu/~breiman/RandomForests/cc_home.htm#ooberr 
#The caret package uses by defualt the Gini importance. Calculate the variable importance using the varImp function 
#in the caret package. What is the order of variable importance?

library(randomForest)
vowel.train$y <- as.factor(vowel.train$y)
vowel.test$y <- as.factor(vowel.test$y)
set.seed(33833)
model <- randomForest(y ~ ., data = vowel.train, importance = FALSE)
order(varImp(model), decreasing=T) #x.2, x.1, x.5, x.6, x.8, x.4, x.9, x.3, x.7,x.10