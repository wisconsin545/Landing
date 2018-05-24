# R Linear Models.... 

# programming with data from automobile pricing and bodyfat

library(car) # package associated with Fox and Weisberg(2011)
library(caret) # package from Max Kuhn (2008,2012)

# check out the documentation on CRAN... reference manuals, vinettes

# somewhat confusing... we are using functions from the car package 
# and the cars data frame from the caret package
# see Kuiper and Sklar (2011) for discussion of the cars data 

# Variables of interest
# Price Kelly Blue Book price in 2005
# Make (Buick=1, Cadillac=2, Chevrolet=3, Pontiac=4, Saab=5, Saturn=6) 
# Type (Convertible=1, Coupe=2, Hatchback=3, Sedan=4, Wagon=5) 
# Cyl (number of cylinders: 4, 6, or 8)
# Doors (number of doors: 2, 4) 
# Cruise (1 = cruise control, 0 = no cruise control) 
# Sound (1 = upgraded speakers, 0 = standard speakers) 
# Leather (1 = leather seats, 0 = not leather seats) 
# Mileage (number of miles the car has been driven)
data(cars)
cat("\n","----- Initial Structure of cars data frame -----","\n")
# examine the structure of the initial data frame
print(str(cars))

# set binary factor variables as factor variables
cars$Cruise <- factor(cars$Cruise,levels=c(0,1),labels=c("NO","YES"))
cars$Sound <- factor(cars$Sound,levels=c(0,1),labels=c("NO","YES"))
cars$Leather <- factor(cars$Leather,levels=c(0,1),labels=c("NO","YES"))

# combine binary indicators into a multilevel factor
# we can use a nested ifelse to set the six car makes
# defining a new variable called Make
# note that the recode function from the car package
# will not work here because we are defining one
# multilevel factor using many binary variables
cars$Make <- ifelse((cars$Buick == 1),1,
ifelse((cars$Cadillac == 1),2,
ifelse((cars$Chevy == 1),3,
ifelse((cars$Pontiac == 1),4,
ifelse((cars$Saab == 1),5,6)))))
cars$Make <- factor(cars$Make,levels=c(1,2,3,4,5,6),labels=c("Buick","Cadillac","Chevy","Pontiac","Saab","Saturn"))
# one-by-one we check the coding of cars$Make
table(cars$Buick,cars$Make)
table(cars$Cadillac,cars$Make)
table(cars$Chevy,cars$Make)
table(cars$Pontiac,cars$Make)
table(cars$Saab,cars$Make)
table(cars$Saturn,cars$Make)

# we can use a nested ifelse to set the five car types
# defining a new variable called Type
cars$Type <- ifelse((cars$sedan == 1),4,
ifelse((cars$coupe == 1),2,
ifelse((cars$hatchback == 1),3,
ifelse((cars$convertible == 1),1,5))))
cars$Type <- factor(cars$Type,levels=c(1,2,3,4,5),labels=c("Convertible","Coupe","Hatchback","Sedan","Wagon"))
# one-by-one we check the coding of cars$Type
cat("\n Convertible Test"); table(cars$convertible,cars$Type)
cat("\n Coupe Test"); table(cars$coupe,cars$Type)
cat("\n Hatchback Test"); table(cars$hatchback,cars$Type)
cat("\n Sedan Test"); table(cars$sedan,cars$Type)
cat("\n Wagon Test"); table(cars$wagon,cars$Type)

cat("\n","----- Revised Structure of cars data frame -----","\n")
# we check the structure of the diamonds data frame again
print(str(cars))
                                                                      
# install the lattice graphics package prior to using the library() function

library(lattice) # required for the xyplot() function

# let's prepare a graphical summary of the cars data
# reveals that Buick has only sedans
# only Pontiac and Saab have wagons
xyplot(Price ~ Mileage | Make + Type, 
       data = cars,        
        layout = c(6, 5),
        strip=function(...) strip.default(..., style=1),
        xlab = "Mileage", 
        ylab = "Price")
        
# let's focus upon sedans 
# define sedans data frame with selected variables

sedans <- cars[(cars$Type == "Sedan"),c("Price","Mileage","Make","Cylinder","Doors","Cruise","Sound","Leather")]
print(str(sedans))

# note that all sedans have four doors
print(table(sedans$Doors))

# note that Cylinder and Make are confounded
print(table(sedans$Cylinder,sedans$Make))

# we can use the lm() function for linear regression
# predicting price from combinations of explanatory variables
# we can explore variable transformations
 
# for a generalized linear model we might try using the glm() function 
# to predict channel, internet (YES or NO), from price or other variables
# for logistic regression, we would use glm() with family="binomial"

# the modeling methods we employ should make sense for the case study problem
# ---------------------------------------------

# for the purposes of demonstration we begin by adding an identifier to the cases
# here we are using and ID that is identical with the row numbers
# this ID may be useful in identifying outliers in the training or test data
sedans$ID <- seq(1:nrow(sedans)) 
head(sedans)

# add a key for dividing a data frame into training and test
# with about 2/3 of the data in training and 1/3 in test
# begin by setting the seed so we can reproduce the results
# on subsequent runs of the analysis
set.seed(4444)
partition <- sample(nrow(sedans)) # permuted list of index numbers for rows
sedans$Group <- ifelse((partition < nrow(sedans)/(3/2)),1,2)
sedans$Group <- factor(sedans$Group,levels=c(1,2),labels=c("TRAIN","TEST"))

print(table(sedans$Group))
head(sedans)

sedans.train <- sedans[(sedans$Group == "TRAIN"),]
print(str(sedans.train))

sedans.test <- sedans[(sedans$Group == "TEST"),]
print(str(sedans.test))


# prior to specifying the model as an additive model only
# check for evidence of interactions among the factor variables
# also ensure that values of binary factors are available 
# across all sedan makes and look for factor differences
# between the levels of each binary (NO/YES) factor
par(mfrow=c(3,1)) # for more than one plot on a page
with(sedans.train, {interaction.plot(Make,Cruise,Price,type="b",pch=c(1,16),cex=2,ylim=range(Price),leg.bty="o")})

with(sedans.train, {interaction.plot(Make,Sound,Price,type="b",pch=c(1,16),cex=2,ylim=range(Price),leg.bty="o")})

with(sedans.train, 
{interaction.plot(Make,Leather,Price,type="b",pch=c(1,16),cex=2,ylim=range(Price),leg.bty="o")})
par(mfrow=c(1,1)) # returns to one plot per page

# lattice plot for key explanatory variables
xyplot(Price ~ Mileage | Make, 
       data = sedans,        
        layout = c(6, 1),
        aspect=1,
        strip=function(...) strip.default(..., style=1),
        xlab = "Mileage", 
        ylab = "Price")

# same lattice plot for key explanatory variables to pdf file
pdf(file="plot_sedans_mileage_and_make.pdf",width=11,height=8.5)
xyplot(Price ~ Mileage | Make, 
       data = sedans,        
        layout = c(6, 1),
        aspect=1,
        strip=function(...) strip.default(..., style=1),
        xlab = "Mileage", 
        ylab = "Price")
dev.off() # finish the pdf work by turning off the device

# fit a linear least-squares regresssion model 
lm.model.fit.train <- lm(Price ~ Mileage + Make,data = sedans.train) 

print(lm.model.fit.train)
summary(lm.model.fit.train)

confint(lm.model.fit.train) # compute confidence intervals for regression coefficients

# note difference between anova from R base stat package and Anova from car package
# Anova is generally preferred because it provides tests that are more
# easily interpreted and do not depend upon the order of the effects
# Also Anova, with its type II sums of squares, provides F tests
# with the same p-values as t values for individual coefficients
# on continuous and binary factors... which makes sense to many users.
Anova(lm.model.fit.train) # Anova with type II sum of squares from car package

vif(lm.model.fit.train) # variance inflation factors with car package vif() function

# standard diagnostic plots for lm object using R base stat package
par(mfrow=c(2,2)) # for more than one plot on a page
plot(lm.model.fit.train)
par(mfrow=c(1,1)) # returns to one plot per page

# plot confidence ellipses using another function from car package
# here we will set up plot output with four plots on one page with par()
with(sedans.train, {dataEllipse(Mileage,Price,levels=c(0.5,0.75,0.90))})

# marginal model plots using another function from car package
# here we will set up plot output with four plots on one page with par()
with(sedans.train, {marginalModelPlots(lm.model.fit.train)})

# added variable plots using another function from car package
# here we will set up plot output with four plots on one page with par()
with(sedans.train, {avPlots(lm.model.fit.train)})

# influence index plot from car package
with(sedans.train, {influenceIndexPlot(lm.model.fit.train,id.n=3)})

sedans.train$PredPrice <- predict(lm.model.fit.train)

# plot of observed Kelly Blue Book price versus predicted price for the training data
with(sedans.train,{plot(Price/1000,PredPrice/1000,xlim=c(min(Price/1000,PredPrice/1000),max(Price/1000,PredPrice/1000)),ylim=c(min(Price/1000,PredPrice/1000),max(Price/1000,PredPrice/1000)),xlab="Price (thousands of dollars)",ylab="Predicted Price (thousands of dollars)",las=1)})
# add diagonal line for Kelly Blue Book price exactly equal to predicted price
lines(c(10,50),c(10,50),col="red",cex=2,type="l") # the perfect-prediction line
title("Training Set Prediction Performance")
# look for variation around the perfect-prediction line
# note that the results from this plot suggest that an 
# interaction between Mileage and Make may be useful

# try an interaction model 
lm.interaction.model.fit.train <- lm(Price ~ Mileage * Make,data = sedans.train) 
print(lm.interaction.model.fit.train)
summary(lm.interaction.model.fit.train)
confint(lm.interaction.model.fit.train) 
Anova(lm.interaction.model.fit.train) 

# perhaps a segmented regression would work
# that is, fit a separate model for Cadillacs 
# we will leave this as an exercise

# out-of-sample predictive performance... use the test set
sedans.test$PredPrice <- predict(lm.model.fit.train,newdata=sedans.test)

# plot of observed Kelly Blue Book price versus predicted price for the training data
with(sedans.test,{plot(Price/1000,PredPrice/1000,xlim=c(min(Price/1000,PredPrice/1000),max(Price/1000,PredPrice/1000)),ylim=c(min(Price/1000,PredPrice/1000),max(Price/1000,PredPrice/1000)),xlab="Price (thousands of dollars)",ylab="Predicted Price (thousands of dollars)",las=1)})
# add diagonal line for Kelly Blue Book price exactly equal to predicted price
lines(c(10,50),c(10,50),col="red",cex=2,type="l") # the perfect-prediction line
title("Test Set Prediction Performance")
# note acceptable out-of-sample variation around the perfect-prediction line

# R for statistical graphics and data visualization...
# The lattice package provides functions for generating a picture
# of data and model predictions that is easy to understand.
#
# examine the prediction performance in training and test side-by-side
# using lattice graphics... merging the training and test data frames
# the groups argument permits the coloring of points for make of sedan
# a panel function is used to set up the perfect-prediction lines
# the key argument and simpleKey function set up the legend for Make
sedans.merged <- rbind(sedans.train,sedans.test)
pdf("plot_training_and_test_prediction_performance.pdf",width=11,height=8.5)
xyplot(PredPrice ~ Price | Group, 
       groups = Make,
       data = sedans.merged,        
        layout = c(2, 1),
        xlim=c(8000,46000),ylim=c(8000,46000),
        aspect=1,
        panel=function(x,y, ...)
            {panel.xyplot(x,y,...)
             panel.segments(10000,10000,44000,44000,col="black",cex=2)
            },
        strip=function(...) strip.default(..., style=1),
        xlab = "Kelly Blue Book Price", 
        ylab = "Predicted Price",
        main="Prediction Performance of Linear Regression Model",
        key=simpleKey(text=levels(sedans.merged$Make),space="right",points=TRUE))
par(mfrow=c(1,1)) # back to one plot per page
dev.off() # finish the pdf work by turning off the device


# --------------------------------------------------------------------------
# there are various approaches to explanatory variable subset selection
# In our work with the cars and sedans data, we used statistical graphics
# and contingency tables to see which variables made sense, which were
# the most logical choices as explanatory variables in a linear model.
# That approach worked well for data at hand... just a few variables
# with certain of the binary factors associated with the make of automobile.
#
# In problems with larger numbers of explanatory variables, it makes
# good sense to utilize statistical tools for explanatory variables
# subset selection. Stepwise variable selection is one approach.
# There are many other approaches. As well, we continue to utilize
# statistical graphics to explore the data, to look for problems
# with our models (diagnostic graphics, outlier and influential observation
# identification), to consider possible transformations, and to present
# model results to management. 

# to demonstrate we will go back to the bodyfat data 
# --------------------------------------------------------------------------

library(MMST)
library(MASS)
data(bodyfat)

# a useful statistical graphic would be a correlation levelplot
# consider a three-level color ramp with white for zero correlation
library(lattice)

# reorder the variables based upon correlation with bodyfat
bodyfat.cormat <- cor(bodyfat)
bodyfat.cormat.line <- bodyfat.cormat["bodyfat",]

ordered.bodyfat.cormat <- bodyfat.cormat[names(sort(bodyfat.cormat.line,decreasing=TRUE)),names(sort(bodyfat.cormat.line,decreasing=FALSE))]

# use x=list(rot=90) for axis tick labels perpendicular to the horizontal axis
levelplot(ordered.bodyfat.cormat,col.regions=colorRampPalette(c("red", "white", "blue")), xlab=NULL, ylab=NULL, scales=list(tck=0, x=list(rot=90)), main="Correlation Levelplot for Bodyfat Data")

# --------------------------------------------------------------------------
# (1) stepwise regression

# stepwise regression using MASS stepAIC Venables and Ripley (2002, 177-178)
# this program goes from the upper model to the lower model
# dropping one term at a time based upon Akaike's AIC

upper.lm.model <- lm(bodyfat ~ age + weight + height + neck + chest + abdomen + hip + thigh + knee + ankle + biceps + forearm + wrist, data=bodyfat)
lower.lm.model <- lm(bodyfat ~ 1,data=bodyfat) # intercept only model

stepwise.lm.model <- stepAIC(upper.lm.model,lower.lm.model,trace=T)

# show the model that has been automatically selected by stepAIC
print(stepwise.lm.model)
summary(stepwise.lm.model)
confint(stepwise.lm.model) # compute confidence intervals for regression coefficients
Anova(stepwise.lm.model) # Anova with type II sum of squares from car package
vif(stepwise.lm.model) # variance inflation factors with car package vif() function
# note that there is still work to do here... given the high variance inflation factors

# --------------------------------------------------------------------------
# (2) all possible subsets regression 

library(leaps)
input.data.frame <- bodyfat[,c("bodyfat","age","weight","height","neck","chest","abdomen","hip","thigh","knee","ankle","biceps","forearm","wrist")]  
maxfactors <- length(names(input.data.frame)) -1 # number of possible explanatory variables

# here we will select the five (nbest=5) best subsets of each possible size (number of explanatory variables)
best.combinations <- regsubsets(bodyfat ~.,data = input.data.frame,method="exhaustive",nbest=5,nvmax=maxfactors)

pdf(file="plot_all_possible_subsets_regression_bodyfat.pdf",width=10.5,height=8.0)
par(mar=c(6,6,6,5),cex=.8)
plot(best.combinations,labels=best.combinations$xnames,main="All Possible Subsets Regression for Bodyfat Case",scale="Cp")
dev.off()

# reviewing the plotted results, we see that the set of explanatory variables
# yielding the lowest Mallow's Cp subset... then we fit a model with seven explanatory variables
best.subset.lm.model <- lm(bodyfat ~ age + weight + neck + abdomen + thigh + forearm + wrist,data=bodyfat)

# show the model that has been automatically selected by best subsets regression
print(best.subset.lm.model)
summary(best.subset.lm.model)
confint(best.subset.lm.model) # compute confidence intervals for regression coefficients
Anova(best.subset.lm.model) # Anova with type II sum of squares from car package
vif(best.subset.lm.model) # variance inflation factors with car package vif() function
# note that there is still work to do here... given the high variance inflation factors

# what about just four variables selected from a review of the plot
best.four.subset.lm.model <- lm(bodyfat ~ weight + abdomen + forearm + wrist,data=bodyfat)
print(best.four.subset.lm.model)
summary(best.four.subset.lm.model)
confint(best.four.subset.lm.model) # compute confidence intervals for regression coefficients
Anova(best.four.subset.lm.model) # Anova with type II sum of squares from car package
vif(best.four.subset.lm.model) # variance inflation factors with car package vif() function

# is this model the best subset of four... check it out
best.combinations.four <- regsubsets(bodyfat ~.,data = input.data.frame,method="exhaustive",nbest=1,nvmax=4)
pdf(file="plot_all_possible_subsets_regression_four_bodyfat.pdf",width=10.5,height=8.0)
par(mar=c(6,6,6,5),cex=.8)
plot(best.combinations.four,labels=best.combinations.four$xnames,main="All Possible Subsets Regression for Bodyfat Case (Maximum of Four Explanatory Variables)",scale="Cp")
dev.off()

# --------------------------------------------------------------------------
# (3) random forests... this we will leave for the R tutorial about trees

# --------------------------------------------------------------------------
# References

# Fox, J. & Weisberg, S. (2011). An R companion to applied regression (2nd ed.). Thousand Oaks, CA: Sage. Reference for the car package, which includes many useful functions for model fitting and diagnositcs. [ISBN-13 978-1412975148]

# Izenman, A. J. (2008). Modern multivariate statistical techniques: Regression, classification, and manifold learning. New York, NY: Springer. Comprehensive modeling reference covering traditional statistical models as well as machine learning models. Source for the MMST package with many data sets, including bodyfat. [ISBN-13: 978-0387781884]

# Kuhn, M. (2008). Building predictive models in R using the caret package. Journal of Statistical Software, 28(5). Many usefult functions for model fitting and evaluation. 

# Kuhn, M. (2012). Package caret: Classification and regression training. Reference manual, dated October 3, 2012, retrieved from the World Wide Web at http://cran.r-project.org/

# Kuiper, S. & Sklar, J. (2011). Practicing statistics: Guided investigations for the second course. Upper Saddle River, N.J.: Pearson. [ISBN-13: 9780321586018]  Kuiper and Sklar (2011, pp. 67-101) Chapter 3. Multiple regression: How much is your car worth?  retrieved from the World Wide Web, October 4, 2012, at http://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=2&ved=0CC0QFjAB&url=http%3A%2F%2Fwww.pearsonhighered.com%2Fkuiper1einfo%2Fassets%2Fpdf%2FKuiper_Ch03.pdf&ei=v0ZuUJe1EuPLyQG8xoCYBQ&usg=AFQjCNG-FGhuggphfx4L9ee5cMjaLn22Sg&sig2=pj5RyKcQwpVuB65tRH54Pg

# Matloff, N. (2011). The art of R programming: A tour of statistical software design. San Francisco, CA: No Starch Press. Good general reference for R programming. [ISBN-13: 978-1593273842]

# Sarkar, D. (2008). Lattice: Multivariate data visualization with R. New York: Springer. Expanded documentation for the lattice package for data visualization. [ISBN-13: 978-0-387-75968-5]

# Venables, W. N. & Ripley, B. D. (2002). Modern applied statistics with S (4th ed.). New York: Springer. Source for the MASS package. An S/R classic, "the mustard book." Chapter 6 covers linear models. [ISBN10: 0-387-95457-0]