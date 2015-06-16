#Reading and Cleaning Data
#Read both training and testing instances. I have used a function named LOAD to load the packages that I will use later.

setwd("/Users/pacha/Documents/Coursera/tareas y controles/Practical Machine Learning/proyecto")

load <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg))
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
} 

packages <- c("data.table", "caret", "randomForest", "foreach", "rpart", "rpart.plot", "corrplot")
load(packages)

training_data <- read.csv("pml-training.csv", na.strings=c("#DIV/0!"," ", "", "NA", "NAs", "NULL"))
testing_data <- read.csv("pml-testing.csv", na.strings=c("#DIV/0!"," ", "", "NA", "NAs", "NULL"))

#I need to drop columns with NAs, drop highly correlated variables and drop variables with 0 (or approx to 0) variance. 

str(training)
cleantraining <- training_data[, -which(names(training_data) %in% c("X", "user_name", "raw_timestamp_part_1", "raw_timestamp_part_2", "cvtd_timestamp", "new_window", "num_window"))]
cleantraining = cleantraining[, colSums(is.na(cleantraining)) == 0] #this drops columns with NAs
zerovariance =nearZeroVar(cleantraining[sapply(cleantraining, is.numeric)], saveMetrics=TRUE)
cleantraining = cleantraining[, zerovariance[, 'nzv'] == 0] #to remove 0 or near to 0 variance variables
correlationmatrix <- cor(na.omit(cleantraining[sapply(cleantraining, is.numeric)]))
dim(correlationmatrix)
correlationmatrixdegreesoffreedom <- expand.grid(row = 1:52, col = 1:52)
correlationmatrixdegreesoffreedom$correlation <- as.vector(correlationmatrix) #this returns the correlation matrix in matrix format
removehighcorrelation <- findCorrelation(correlationmatrix, cutoff = .7, verbose = TRUE)
cleantraining <- cleantraining[, -removehighcorrelation] #this removes highly correlated variables (in psychometric theory .7+ correlation is a high correlation)

for(i in c(8:ncol(cleantraining)-1)) {cleantraining[,i] = as.numeric(as.character(cleantraining[,i]))}

for(i in c(8:ncol(testing_data)-1)) {testing_data[,i] = as.numeric(as.character(testing_data[,i]))} #Some columns were blank, hence are dropped. I will use a set that only includes complete columns. I also remove user name, timestamps and windows to have a light data set.

featureset <- colnames(cleantraining[colSums(is.na(cleantraining)) == 0])[-(1:7)]
modeldata <- cleantraining[featureset]
featureset #now we have the model data built from our feature set.

##Cross-Validation
#I need to split the sample in two samples. This is to divide training and testing for cross-validation.

idx <- createDataPartition(modeldata$classe, p=0.6, list=FALSE )
training <- modeldata[idx,]
testing <- modeldata[-idx,]

control <- trainControl(method="cv", 5)
model <- train(classe ~ ., data=training, method="rf", trControl=control, ntree=250)
model

predict <- predict(model, testing)
confusionMatrix(testing$classe, predict)

accuracy <- postResample(predict, testing$classe)
accuracy

result <- predict(model, training[, -length(names(training))])
result

treeModel <- rpart(classe ~ ., data=cleantraining, method="class")
prp(treeModel) 

##############################

pml_write_files = function(x){
  n = length(x)
  for(i in 1:n){
    filename = paste0("problem_id_",i,".txt")
    write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
  }
}

testing_data <- testing_data[featureset[featureset!='classe']]
answers <- predict(model, newdata=testing_data)
answers

pml_write_files(answers)
