# Daniel Prusinski Programming Assignment 3: Evaluating Classification Models in R

####### My comments look like this.

####### DO NOT INSTALL PACKAGES THAT ARE ALREADY INSTALLED
####### After you install once, you are done installing
####### for future running porgrams in the future.
####### This will save you time with every computer run.

####### Also only use the library command for the packages 
####### you will be using in this particular program.
####### This will save you time as well as possible 
####### function name overlapping issues... which sometimes occur.

####### I have commented out the things you do not need.

# install.packages("ggplot2")  #Package for quick plots
# library(ggplot2)
# install.packages("corrplot")  #Package for exploring relationships betweeen data using # visual corrplots
# library(corrplot)
# install.packages("lattice")  #Lattice, this produces high resolution plots with great default formatting
# install.packages("car") # We will need this for the regression model
# library (car)
# install.packages("tree")
# library(tree)
# install.packages("lattice")
# library(lattice)
# install.packages("MASS")
# library (MASS)
# install.packages("rpart")
# library ("rpart")
# install.packages("randomForest")
library ("randomForest")
# install.packages("caret")
library ("caret")
# install.packages("e1071")
# library ("e1071")
# install.packages("cvTools")
# library(cvTools)
# Let's take a look at the data
library(MMST)

data(spambase)
print(str(spambase))
# I want to start with a Random Forest, which is a committee method.
# I will first split my data into training and testing
set.seed(9999)
partition <- sample(nrow(spambase))
spambase$Group <- ifelse((partition < nrow(spambase)/(3/2)),1,2)
spambase$Group <- factor(spambase$Group,levels=c(1,2),labels=c("TRAIN","TEST"))
print(table(spambase$Group))
spambase.train <- spambase[(spambase$Group == "TRAIN"),]
print(str(spambase.train))
spambase.test <- spambase[(spambase$Group == "TEST"),]
print(str(spambase.test))
# I now need to create the model
spam.classification.model <- {class ~   make     +
address  +
all  +
xd  +
our  +
over  +
remove  +
internet  +
order  +
mail  +
receive  +
will  +
people  +
report  +
addresses  +
free  +
business  +
email  +
you  +
credit  +
your  +
font  +
x000  +
money  +
hp  +
hpl  +
george  +
x650  +
lab  +
labs  +
telnet  +
x857  +
data  +
x415  +
x85  +
technology  +
x1999  +
parts  +
pm  +
direct  +
cs  +
meeting  +
original  +
project  +
re  +
edu  +
table  +
conference  +
x.  + 
x..  +
x...1  +
x..1  +
x..2  +
x..3  +
crla  +
crll  +
crrt  
}

# Now for the Random Forest
train.data.frame.rf <- randomForest(spam.classification.model,
  data=spambase.train, mtry=3, importance=TRUE, na.action=na.omit)

# review the random forest solution     
print(train.data.frame.rf)

# check importance of the individual explanatory variables
pdf(file = "fig_sentiment_random_forest_importance.pdf",
width = 11, height = 8.5)
varImpPlot(train.data.frame.rf, main = "")
dev.off()

######## Looks like you have something that worked here.
######## Random forest results look pretty good. 
######## You could write these up referring to the plot.


# Now let's check to see how it does with predicting
spambase.train$pred.rf <- predict(train.data.frame.rf, type="class",
  newdata = spambase.train)


####### Think about the problem. This is a classification problem.
####### Root mean-squared error is not relevant to classification.
####### I have commente out the following code.

# root-mean-squared for random forest on training set
# I am sure the error that I have made is small, but it has managed to stop my whole project
####### print(rmspe(spambase.train$class, spambase.train$pred.rf))


##################################################################
##################################################################
##################################################################
###This part is still being worked out

###### You already did this... I comment it out.
# Now let's check to see how it does with predicting
###### spambase.train$pred.rf <- predict(train.data.frame.rf, type="class",
######  newdata = spambase.train)


###### You need to identify the predicted and actual values
###### for your problem. The following code does not do that.
###### So I comment it out.

###### train.pred.rf.performance <-
######   confusionMatrix(data = spambase.train$pred.rf),
######   reference = train.data.frame.rf)

###### Here is the correct code for printing the confusion matrix.
confusionMatrix(data = spambase.train$pred.rf,
  reference = spambase.train$class)

###### Notice that we could see the confusion matrix directly as follows:
with(spambase.train, table(pred.rf,class))

####### As a general programming strategy.
####### You should not be just copying code and using it as is.
####### Use example code to give you an idea of how to do things.
####### Think about the problem. You are classifying mail as 
####### true e-mail versus spam, not DOWN and UP.
####### DOWN and UP, as well as thumbsupdown were used in the
####### problem I was working on in my book. Your problem
####### is similar, but not identical. Your variable names
####### should be set for the problem you are working on.
####### Your labels should be for the problem you are working on.
#######
####### How does R know what thumbsupdown is?
####### Your have not defined this variable previously.
####### thumbsupdown has nothing to do with your problem.

####### I have commented out unnecessary code below.

#I need to add this before
# This is where I am stuck, how do I do this for my the spam data set?
# The code in the book has loops in it, and this step is essential
####### train.data.frame$thumbsupdown <- ifelse((train.data.frame$rating > 5), 2, 1)
####### train.data.frame$thumbsupdown <-
#######   factor(train.data.frame$thumbsupdown, levels = c(1,2),
#######     labels = c("DOWN","UP"))

# I could not figure out how to get the confusion matrix, so this is what I have
#Which is prediction
# use the model fit to the training data to predict the the test data    
#######spambase.train$pred.rf <- predict(train.data.frame.rf, type="class",
#######   newdata = spambase.test)

####### what you want to do is use the model developed on the
####### training set and evaluate it on the test set
####### We explained how to do this in the discussion board posts.
spambase.test$pred.rf <- predict(train.data.frame.rf, type="class",
     newdata = spambase.test)

###### Here is the correct code for printing the confusion matrix.
###### Same format as before but now with the test set.
confusionMatrix(data = spambase.test$pred.rf,
  reference = spambase.test$class)

###### Notice that we could see the confusion matrix directly as follows:
with(spambase.test, table(pred.rf,class))



###### Why are you computing correlations for binary classification 
###### variables? This is not a regression problem. This is 
###### a classification problem. 


#############################################
#############################################
#############################################
####### let's examine the correlations across the variables before we begin modeling
######spam.cor <- spambase.train[,c("make",
######"address",
######"all",
######"xd",
######"our",
######"over",
######"remove",
######"internet",
######"order",
######"mail",
######"receive",
######"will",
######"people",
######"report",
######"addresses",
######"free",
######"table",
######"conference",
######"x.",
######"x..",
######"x...1",
######"x..1",
######"x..2",
######"x..3",
######"crla",
######"crll",
######"crrt"
######)]

###### spambase.train.cormat <- cor(as.matrix(spam.cor))
###### spambase.train.cormat.line <- spambase.train.cormat["class",]
#Well, it sucks this didn't work
###### Who cares about correlations here? 
###### They are not relevant to or needed for the problem at hand.


##################################
##################################
##################################
#Now let's try logistic regression
logistic.regression.fit <- glm(spam.classification.model,
  family=binomial(link=logit), data = spambase.train)
print(summary(logistic.regression.fit))

###### This worked... write it up.

# obtain predicted probability values for training set
###### logistic.regression.pred.prob <-
######   as.numeric(predict(logistic.regression.fit, newdata = spambase.train,
######   type="response"))

###### Again. You are taking code from another problem
###### and trying to use it here without changing it 
###### to suit the problem at hand.
###### You are not classifying text on a rating scale.
###### You are classifying e-mail versus spam.

###### spambase.train$pred.logistic.regression <-
######  ifelse((logistic.regression.pred.prob > 0.5),2,1)

###### spambase.train$pred.logistic.regression <-
######   factor(spambase.train$pred.logistic.regression, levels = c(1,2),
######     labels = c("DOWN","UP"))

#######Here we go again same place I am getting stuck
###### train.pred.logistic.regression.performance <-
######   confusionMatrix(data = spambase.train$pred.logistic.regression,
######   reference = spambase.train$class, positive = "UP")

###### Carry out the same sort of thing we did for random forests....
###### Here is the way to do it for the training set....

spambase.train$pred.prob.lr <- 
  as.numeric(predict(logistic.regression.fit, newdata = spambase.train, type="response"))

spambase.train$pred.lr <- ifelse((spambase.train$pred.prob.lr > 0.5),2,1)
spambase.train$pred.lr <-
   factor(spambase.train$pred.lr, levels = c(1,2),
       labels = c("email","spam"))

with(spambase.train, table(pred.lr,class))

confusionMatrix(data = spambase.train$pred.lr,
  reference = spambase.train$class)

###### Now do it for the test set.....


























