################################SPLIT INTO TRAINING AND TESTING#####################################

#In order to assess how well the models predict/classify, the data must be divided into testing

# and training, below are the steps I took heavily relying on Dr. Miller's Linear Code.

set.seed(1256)

partition <- sample(nrow(spambase))  #Create a vector of randomized row

spambase$Group <- ifelse((partition < nrow(spambase)/(3/2)),1,2)  #Assigne 66.6% to 1 and rest to 2

spambase$Group <- factor(spambase$Group,levels=c(1,2),labels=c("TRAIN","TEST"))

print(table(spambase$Group))

spambase.train <- spambase[(spambase$Group == "TRAIN"),]

print(str(spambase.train))

spambase.test <- spambase[(spambase$Group == "TEST"),]

print(str(spambase.test))

 

###############################FOWARD/BACKWARD ELIMINATION LOGISTIC REGRESSION BEST MODEL####################################

spambase.train$Group <- NULL  #single valued factors cause errors and this removes the offending column

spam.logistic.train <- glm(class ~ . -classdigit , family=binomial(link="logit"), data=spambase.train)

step_glm <- step(spam.logistic.train, direction = "both", trace=FALSE)

step_glm

 

plot(Menarche/Total ~ Age, data=spambase.train)

lines(menarche$Age, glm.out$fitted, type="l", col="red")

title(main="Menarche Data with Fitted Logistic Regression Line")

 

#Predict Values

spambase.test$log_class <- predict(step_glm, newdata = spambase.test,type="response")

 

#############################Naive Bayes Classifier#######################################################

install.packages("e1071")

library(class)

library(e1071)

 

naivebayes<- naiveBayes(class ~ make + address + all + xd + our + over + remove

+ internet + order + addresses + free + business + you + credit + your + x000

+ money + hp + hpl + george + x650 + lab + data + x415 + x85 + technology + x1999 + parts + pm

+ cs + meeting + original + project + re + edu +table + conference + x.  +  x..  +  x..1  + x..2 

+ x..3 + crla + crll + crrt  , data = spambase.train)

spambase.test$naivebayes_class <- predict(naivebayes, newdata = spambase.test)

 

##############################Neural Network######################################

mygrid <- expand.grid(.decay=c(0.5, 0.1, .001), .size=c(3,4,5,6,7))  #Training Grid

#Train ANN

nnet.train <- train(class ~ make + address + all + xd + our + over + remove

+ internet + order + addresses + free + business + you + credit + your + x000

+ money + hp + hpl + george + x650 + lab + data + x415 + x85 + technology + x1999 + parts + pm

+ cs + meeting + original + project + re + edu +table + conference + x.  +  x..  +  x..1  + x..2 

+ x..3 + crla + crll + crrt

,spambase.train,trace = FALSE, method="nnet", maxit=1000, tuneGrid=mygrid)

summary(nnet.train)

spambase.test$nnet<- predict(nnet.train, newdata = spambase.test)

 

 

#################################Support Vector Machine##########################

install.packages("kernlab")

library(kernlab)

svm <- ksvm(class ~ make + address + all + xd + our + over + remove

+ internet + order + addresses + free + business + you + credit + your + x000

+ money + hp + hpl + george + x650 + lab + data + x415 + x85 + technology + x1999 + parts + pm

+ cs + meeting + original + project + re + edu +table + conference + x.  +  x..  +  x..1  + x..2 

+ x..3 + crla + crll + crrt

,data=spambase.train,type="C-svc",kernel='vanilladot',C=10,prob.model=TRUE)

svm

spambase.test$svm<- predict(svm, newdata = spambase.test)