#Daniel Prusinski Programming Assignment 2: Evaluating Regression Models in R

install.packages("ggplot2")  #Package for quick plots
library(ggplot2)
install.packages("corrplot")  #Package for exploring relationships betweeen data using visual corrplots
library(corrplot)
install.packages("lattice")  #Lattice, this produces high resolution plots with great default formatting
install.packages("car") # We will need this for the regression model
library (car)
install.packages("tree")
library(tree)
install.packages("lattice")
library(lattice)
install.packages("MASS")
library (MASS)
install.packages("rpart")
library ("rpart")

#In order to access the csv file in a Windows enviornment here are the step I followed:
# 1: Save the CSV file somewhere that you can easily naviagate to.
# 2: Open R 
# 3: 	Have your cursor in the R Console Window
# 4: 		Click File --> Change Dir...
# 5:			In this window, navigate to the folder in which the CSV file is saved
# 6:				Click OK when you are at the folder
# 7:					In the R Console read in the data: 
diamonds <- read.csv("two_months_salary(2).csv")
# 8: 						You should be good to go run this to make sure: 
print(str(diamonds))

#Initial Parametric Analysis of Diamond Data 
summary(diamonds)
print(str(diamonds))

# we might want to transform the response variable price using a log function
# Let's first take a look at the current distribution 
Price <- density(diamonds$price)
plot (Price)
polygon(Price, col="red", border="blue")

# we might want to transform the response variable price using a log function
diamonds$logprice <- log(diamonds$price)
lprice <- density(diamonds$logprice)
plot (lprice)
polygon(lprice, col="red", border="blue")
#The distibution follows a more normal distribution

# I will now create a scatter plot with each of the predictor variables
# plotted against the response variable. 

#We are now going to create a graphical summary of the data
# we note that price and carat are numeric variables with a strong relationship
# also cut and channel are factor variables related to price
# showing the relationship between price and carat, while conditioning
# on cut and channel provides a convenient view of the diamonds data
# in addition, we jitter to show all points in the data frame
xyplot(jitter(logprice) ~ jitter(carat) | channel + cut, 
       data = diamonds,
        aspect = 1, 
        layout = c(3, 2),
        strip=function(...) strip.default(..., style=1),
        xlab = "Size or Weight of Diamond (carats)", 
        ylab = "Price")

xyplot(jitter(logprice) ~ jitter(color) | channel + cut, 
       data = diamonds,
        aspect = 1, 
        layout = c(3, 2),
        strip=function(...) strip.default(..., style=1),
        xlab = "Color", 
        ylab = "Price")

xyplot(jitter(logprice) ~ jitter(clarity) | channel + cut, 
       data = diamonds,
        aspect = 1, 
        layout = c(3, 2),
        strip=function(...) strip.default(..., style=1),
        xlab = "Clarity", 
        ylab = "Price")

#In order to assess how well the models predict/classify, the data must be divided into testing
# and training, below are the steps I took heavily relying on Dr. Miller's Linear Code.
set.seed(4444)
partition <- sample(nrow(diamonds))
diamonds$Group <- ifelse((partition < nrow(diamonds)/(3/2)),1,2)
diamonds$Group <- factor(diamonds$Group,levels=c(1,2),labels=c("TRAIN","TEST"))
print(table(diamonds$Group))
diamonds.train <- diamonds[(diamonds$Group == "TRAIN"),]
print(str(diamonds.train))
diamonds.test <- diamonds[(diamonds$Group == "TEST"),]
print(str(diamonds.test))

#I am now going to fit a linear model to the training data
mod <- lm(price ~ carat, data=diamonds.train)
r.rmse <- sqrt(mean(diamonds.train$residuals^2)) # Root Mean Square Error Calculation
print (r.rmse) # I will compare this to the other models.
summary(mod)
scatterplot(carat ~ price, data=diamonds.train, id.n=1)

#Multiple Regression
multiple.r.train <- lm(logprice ~ color + carat + clarity + cut + channel +store,
 data=diamonds.train)
summary(multiple.r.train)
confint(multiple.r.train) # compute confidence intervals for regression coefficients
Anova(multiple.r.train) # Anova with type II sum of squares from car package
vif(multiple.r.train) # variance inflation factors with car package vif() function
r.rmse <- sqrt(mean(multiple.r.train$residuals^2)) # Root Mean Square Error Calculation
print (r.rmse) # I will compare this to the other models.
multiple.r.train1 <- lm(logprice ~ color + carat, data=diamonds.test) 
summary(multiple.r.train1)
par(mfrow=c(2,2)) # for more than one plot on a page
plot(multiple.r.train)
par(mfrow=c(1,1)) # returns to one plot per page

#I now want to use stepwise to eliminate burdonsome variables
# --------------------------------------------------------------------------
# (1) stepwise regression

# stepwise regression using MASS stepAIC Venables and Ripley (2002, 177-178)
# this program goes from the upper model to the lower model
# dropping one term at a time based upon Akaike's AIC
upper.lm.model <- lm(price ~color + carat + clarity + cut + channel +store, data=diamonds)
lower.lm.model <- lm(price ~ 1,data=diamonds) # intercept only model

stepwise.lm.model <- stepAIC(upper.lm.model,lower.lm.model,trace=T)

#This is the model
multiple.r.train <- lm(logprice ~ color + carat + clarity + cut +store,
 data=diamonds.train)

confint(stepwise.lm.model) # compute confidence intervals for regression coefficients
Anova(stepwise.lm.model) # Anova with type II sum of squares from car package
vif(stepwise.lm.model) # variance inflation factors with car package vif() function

#Testing the data on the test set
diamonds.test$predlogprice <- predict(multiple.r.train, newdata = diamonds.test)
#Then you will have both the actual logprice for the test data and the predicted logpice
# from the test data. Correlate them and square that correlation to get the proportion of 
# response variance accounted for in the test set. Or use your formula for root-mean-squared 
# error on these test data.

diamonds.test$residuals <- diamonds.test$logprice - diamonds.test$predlogprice

test.r.rmse <- sqrt(mean(diamonds.test$residuals^2)) # Root Mean Square Error Calculation
print (test.r.rmse) # provides test performance measure to compare with other models 

#To get an even better sense for out-of-sample predictive performance, try computing the root-mean-squared error
#for a thousand runs of this type, changing the random number seed for each run. 
#This would move you in the direction of conducting a statistical simulation or benchmark experiment.

####################Tree regression#################################
# This is done using the rpart package
Seeing that we have the optimum model from linear regression, lets see how regression tree
# does with the same model.

tree.train<- rpart(formula = logprice ~ cut + store + carat + clarity + color,
data = diamonds.train)

# This produces the summary metrics
summary(tree.train)

diam.train <- predict(tree.train, data = diamonds.train)

diamonds.train$tree_residuals <- tree.train$logprice - diam.train$tree_pre_logprice

r.rmse <- sqrt(mean(diam.train$residuals^2)) # Root Mean Square Error Calculation
print (r.rmse)

train <- sqrt(mean(tree.train^2))

# This produces the graphic
par(xpd = TRUE)
plot(fit, compress = TRUE)
text(fit, use.n = TRUE)

#Testing Data
diamonds.test$tree_pre_logprice <- predict(tree.train, newdata = diamonds.test)

diamonds.test$tree_residuals <- diamonds.test$logprice - diamonds.test$tree_pre_logprice

test.tree.rmse <- sqrt(mean(diamonds.test$tree_residuals^2)) # Root Mean Square Error Calculation
print (test.tree.rmse) # provides test performance measure to compare with other models









