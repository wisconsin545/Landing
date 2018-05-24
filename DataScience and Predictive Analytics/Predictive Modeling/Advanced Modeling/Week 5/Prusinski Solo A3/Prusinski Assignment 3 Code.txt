#Daniel Prusinski Programming Assignment 3: Evaluating Classification Models in R

library ("randomForest")
library ("caret")
library(MMST)

# Let's take a look at the data 
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

# Now let's check to see how it does with predicting
spambase.train$pred.rf <- predict(train.data.frame.rf, type="class",
  newdata = spambase.train)

###### Here is the correct code for printing the confusion matrix.
confusionMatrix(data = spambase.train$pred.rf,
  reference = spambase.train$class)

###### Notice that we could see the confusion matrix directly as follows:
with(spambase.train, table(pred.rf,class))

###### Here is the correct code for printing the confusion matrix.
###### Same format as before but now with the test set.
spambase.test$pred.rf <- predict(train.data.frame.rf, type="class",
     newdata = spambase.test)

confusionMatrix(data = spambase.test$pred.rf,
  reference = spambase.test$class)



#FOWARD/BACKWARD ELIMINATION LOGISTIC REGRESSION BEST MODEL#

spambase.train$Group <- NULL  #single valued factors cause errors and this removes the offending column

spam.logistic.train <- glm(class ~ . -classdigit , family=binomial(link="logit"), data=spambase.train)

step_glm <- step(spam.logistic.train, direction = "both", trace=FALSE)

step_glm

###### Carry out the same sort of thing we did for random forests....
###### Here is the way to do it for the training set....
spambase.train$pred.prob.lr <- 
  as.numeric(predict(spam.logistic.train, newdata = spambase.train, type="response"))

spambase.train$pred.lr <- ifelse((spambase.train$pred.prob.lr > 0.5),2,1)
spambase.train$pred.lr <-
   factor(spambase.train$pred.lr, levels = c(1,2),
       labels = c("email","spam")) 

with(spambase.train, table(pred.lr,class))

confusionMatrix(data = spambase.train$pred.lr,
  reference = spambase.train$class)

###### Now do it for the test set.....
spambase.test$pred.prob.lr <- 
  as.numeric(predict(spam.logistic.train, newdata = spambase.test, type="response"))

spambase.test$pred.lr <- ifelse((spambase.test$pred.prob.lr > 0.5),2,1)
spambase.test$pred.lr <-
   factor(spambase.test$pred.lr, levels = c(1,2),
       labels = c("email","spam"))

with(spambase.test, table(pred.lr,class))

confusionMatrix(data = spambase.test$pred.lr,
  reference = spambase.test$class, positive = "email")


#Naive Bayes Classifier#

library(class)

library(e1071)
 
naivebayes<- naiveBayes(class ~ make + address + all + xd + our + over + remove

+ internet + order + addresses + free + business + you + credit + your + x000

+ money + hp + hpl + george + x650 + lab + data + x415 + x85 + technology + x1999 + parts + pm

+ cs + meeting + original + project + re + edu +table + conference + x.  +  x..  +  x..1  + x..2 

+ x..3 + crla + crll + crrt  , data = spambase.train)

# review Naive Bayes      
print(naivebayes) 

#This is testing how the model predicts on the training data
spambase.train$naivebayes_class <- predict(naivebayes, newdata = spambase.train)

#ROC Matrix
with(spambase.train, table(naivebayes_class,class))

###### Here is the correct code for printing the confusion matrix.
confusionMatrix(data = spambase.train$naivebayes_class,
  reference = spambase.train$class)

###### Here is the correct code for printing the confusion matrix.
###### Same format as before but now with the test set.
spambase.test$pred.rf <- predict(naivebayes, type="class",
     newdata = spambase.test)

confusionMatrix(data = spambase.test$pred.rf,
  reference = spambase.test$class)

#Support Vector Machine#

install.packages("kernlab")

library(kernlab)

svm <- ksvm(class ~ make + address + all + xd + our + over + remove

+ internet + order + addresses + free + business + you + credit + your + x000

+ money + hp + hpl + george + x650 + lab + data + x415 + x85 + technology + x1999 + parts + pm

+ cs + meeting + original + project + re + edu +table + conference + x.  +  x..  +  x..1  + x..2 

+ x..3 + crla + crll + crrt

,data=spambase.train,type="C-svc",kernel='vanilladot',C=10,prob.model=TRUE)

svm

#This is testing how the model predicts on the training data
spambase.train$svm <- predict(svm, newdata = spambase.train)

with(spambase.train, table(svm,class))

###### Here is the correct code for printing the confusion matrix.
confusionMatrix(data = spambase.train$svm,
  reference = spambase.train$class)

###### Here is the correct code for printing the confusion matrix.
###### Same format as before but now with the test set.
spambase.test$pred.rf <- predict(svm, type="response",
     newdata = spambase.test)

confusionMatrix(data = spambase.test$pred.rf,
  reference = spambase.test$class)

#Neural Network#

mygrid <- expand.grid(.decay=c(0.5, 0.1, .001), .size=c(3,4,5,6,7))  #Training Grid

#Train ANN

nnet.train <- train(class ~ make + address + all + xd + our + over + remove

+ internet + order + addresses + free + business + you + credit + your + x000

+ money + hp + hpl + george + x650 + lab + data + x415 + x85 + technology + x1999 + parts + pm

+ cs + meeting + original + project + re + edu +table + conference + x.  +  x..  +  x..1  + x..2 

+ x..3 + crla + crll + crrt

,spambase.train,trace = FALSE, method="nnet", maxit=1000, tuneGrid=mygrid)

summary(nnet.train)

#This is testing how the model predicts on the training data
spambase.train$nnet<- predict(nnet.train, newdata = spambase.train)

confusionMatrix(data = spambase.train$nnet,
  reference = spambase.train$class)

###### Here is the correct code for printing the confusion matrix.
###### Same format as before but now with the test set.
spambase.test$pred.rf <- predict(svm, type="response",
     newdata = spambase.test)

confusionMatrix(data = spambase.test$pred.rf,
  reference = spambase.test$class)
 
