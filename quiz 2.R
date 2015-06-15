#Question 1
#Load the Alzheimer's disease data using the commands:
library(AppliedPredictiveModeling)
library(caret)
data(AlzheimerDisease)
#Which of the following commands will create training and test sets with about 50% of the observations assigned to each?

adData = data.frame(diagnosis,predictors)
trainIndex = createDataPartition(diagnosis, p = 0.50,list=FALSE)
training = adData[trainIndex,]
testing = adData[-trainIndex,]

#Question 2
#Load the cement data using the commands:
library(AppliedPredictiveModeling)
data(concrete)
library(caret)
set.seed(1000)
inTrain = createDataPartition(mixtures$CompressiveStrength, p = 3/4)[[1]]
training = mixtures[ inTrain,]
testing = mixtures[-inTrain,]
#Make a histogram and confirm the SuperPlasticizer variable is skewed. Normally you might use the log transform to try to make the data more symmetric. Why would that be a poor choice for this variable?

qplot(Superplasticizer, data=training) # OR
ggplot(data=training, aes(x=Superplasticizer)) + geom_histogram() + theme_bw()
#There are values of zero so when you take the log() transform those values will be -Inf.

#Question 3
#Load the Alzheimer's disease data using the commands:
library(caret)
library(AppliedPredictiveModeling)
set.seed(3433)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]
#Find all the predictor variables in the training set that begin with IL. Perform principal components on these 
#variables with the preProcess() function from the caret package. Calculate the number of principal components needed 
#to capture 90% of the variance. How many are there?

IL <- training[,grep('^IL', x = names(training) )]
preProc <- preProcess(IL, method='pca', thresh=0.9, 
                      outcome=training$diagnosis)
preProc$rotation # 9 components

#Question 4
#Load the Alzheimer's disease data using the commands:
library(caret)
library(AppliedPredictiveModeling)
set.seed(3433)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]
#Create a training data set consisting of only the predictors with variable names beginning with IL and the diagnosis. 
#Build two predictive models, one using the predictors as they are and one using PCA with principal components 
#explaining 80% of the variance in the predictors. Use method="glm" in the train function. 
#What is the accuracy of each method in the test set? Which is more accurate?

set.seed(3433)
IL <- grep("^IL", colnames(training), value=TRUE)
ILpredictors <- predictors[, IL]
dataframe <- data.frame(diagnosis, ILpredictors)
inTrain <- createDataPartition(dataframe$diagnosis, p=3/4)[[1]]
training <- df[inTrain, ]
testing <- df[-inTrain, ]
modelFit <- train(diagnosis ~ ., method="glm", data=training)
predictions <- predict(modelFit, newdata=testing)
C1 <- confusionMatrix(predictions, testing$diagnosis)
print(C1)
NONPCA <- C1$overall[1]
NONPCA # Non-PCA Accuracy: 0.65 

modelFit <- train(training$diagnosis ~ ., method="glm", preProcess="pca", data=training, 
                  trControl=trainControl(preProcOptions=list(thresh=0.8)))
C2 <- confusionMatrix(testing$diagnosis, predict(modelFit, testing))
print(C2)
PCA <- C2$overall[1]
PCA # PCA Accuracy: 0.72