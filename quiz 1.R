#Question 1
#Which of the following are steps in building a machine learning algorithm?
#Collecting data to answer the question.

#Question 2
#Suppose we build a prediction algorithm on a data set and it is 100% accurate on that data set. 
#Why might the algorithm not work well if we collect a new data set?
#Our algorithm may be overfitting the training data, predicting both the signal and the noise.

#Question 3
#What are typical sizes for the training and test sets?
#60% in the training set, 40% in the testing set.

#Question 4
#What are some common error rates for predicting binary variables 
#(i.e. variables with two possible values like yes/no, disease/normal, clicked/didn't click)?
#Predictive value of a positive

#Question 5
#Suppose that we have created a machine learning algorithm that predicts whether a link will be clicked with 99% 
#sensitivity and 99% specificity. The rate the link is clicked is 1/1000 of visits to a website. 
#If we predict the link will be clicked on a specific visit, what is the probability it will actually be clicked?

#100,000 VISITS => 100 CLICKS

#SENSITIVITY = 99/100
#99/100 = # OF TRUE POSITIVES / (# OF TRUE POSITIVES + # OF FALSE NEGATIVES) = 99 / (99 + 1)

#SPECIFICITY = 99/100
#99/100 = # OF TRUE NEGATIVES / (# OF TRUE NEGATIVES + # OF FALSE POSITIVES) 
#99 / 100 = (100,000*0.99 - 99) / (100,000*0.99 - 99 + 999)
#99 / 100 = 98,901 / (98,901 + 999) = 98,901 / 99,900

#P(CLICK | PREDICTED CLICK) = TP / (TP + FP) = 99 / (99 + 999) = 99/1098 = 0.09
