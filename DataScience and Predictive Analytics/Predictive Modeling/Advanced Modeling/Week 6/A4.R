# Prusinski A4 - Hierarchial Models 
 
library(car)  # special functions for linear regression
library(lattice)  # graphics package
library(nlme) # for function lme
library (MASS) #for Stepwise
library (Matrix) # for Multilevel Model


dodgers <- read.csv("bobbleheads_v002.csv") # read in the data set
print(str(dodgers))  # check the structure of the data frame

# define an ordered day-of-week variable 
# for plots and data summaries
dodgers$ordered_day_of_week <- with(data=dodgers,
  ifelse ((DayofWeek == "Monday"),1,
  ifelse ((DayofWeek == "Tuesday"),2,
  ifelse ((DayofWeek == "Wednesday"),3,
  ifelse ((DayofWeek == "Thursday"),4,
  ifelse ((DayofWeek == "Friday"),5,
  ifelse ((DayofWeek == "Saturday"),6,7)))))))
dodgers$ordered_day_of_week <- factor(dodgers$ordered_day_of_week, levels=1:7,
labels=c("Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"))
print(str(dodgers))  # check the structure of the data frame

# create summary giveaway promotions variable
# ignore fireworks promotions as they are only at night games
# also some teams like the Dodgers use fireworks on special days only 
# such as Fridays and 4th of July weekend
dodgers$Promotion_Sum <- dodgers$BobbleHd + 
  dodgers$Headgear + 
  dodgers$Shirts

# construct an any promotion factor with labels
dodgers$Promotion <- ifelse((dodgers$Promotion_Sum == 0),0,1)
dodgers$Promotion <-   factor(dodgers$Promotion, 
  levels = c(0,1), labels = c("NO","YES"))

# set labels for the BobbleHd factor variable
dodgers$BobbleHd <- 
  factor(dodgers$BobbleHd, 
  levels = c(0,1), labels = c("NO","YES"))

# set labels for the Headgear factor variable
dodgers$Headgear <- 
  factor(dodgers$Headgear, 
  levels = c(0,1), labels = c("NO","YES"))
  
# set labels for the Shirts factor variable
dodgers$Shirts <- 
  factor(dodgers$Shirts, 
  levels = c(0,1), labels = c("NO","YES"))
print(str(dodgers))  # check the structure of the data frame

# define an ordered month variable 
# for plots and data summaries
dodgers$ordered_month <- with(data=dodgers,
  ifelse ((Month == "April"),4,
  ifelse ((Month == "May"),5,
  ifelse ((Month == "June"),6,
  ifelse ((Month == "July"),7,
  ifelse ((Month == "August"),8,
  ifelse ((Month == "September"),9,10)))))))
dodgers$ordered_month <- factor(dodgers$ordered_month, levels=4:10,
labels = c("April", "May", "June", "July", "Aug", "Sept", "Oct"))

# exploratory data analysis with standard graphics: attendance by day of week
with(data=dodgers,plot(ordered_day_of_week, Attend/1000, 
xlab = "Day of Week", ylab = "Attendance (thousands)", 
col = "violet", las = 1))

# exploratory data analysis with standard graphics: attendance month
with(data=dodgers,plot(ordered_month, Attend/1000, 
xlab = "Month", ylab = "Attendance (thousands)", 
col = "violet", las = 1))

# exploratory data analysis with standard graphics: attendance Team
with(data=dodgers,plot(Team, Attend/1000, 
xlab = "Month", ylab = "Attendance (thousands)", 
col = "violet", las = 1))

# exploratory data analysis with standard graphics: attendance by Promotion
with(data=dodgers,plot(Promotion, Attend/1000, 
xlab = "Promotion", ylab = "Attendance (thousands)", 
col = "violet", las = 1))

# exploratory data analysis with standard graphics: attendance by Weather
with(data=dodgers,plot(TypeOfDay, Attend/1000, 
xlab = "Month", ylab = "Attendance (thousands)", 
col = "violet", las = 1))

# attendance by Team and day/night game
group.labels <- c("Day","Night")
group.symbols <- c(1,20)
group.symbols.size <- c(2,2.75)
bwplot(Team ~ Attend/1000, data = dodgers, groups = Night, 
    xlab = "Attendance (thousands)",
    panel = function(x, y, groups, subscripts, ...) 
       {panel.grid(h = (length(levels(dodgers$Team)) - 1), v = -1)
        panel.stripplot(x, y, groups = groups, subscripts = subscripts, 
        cex = group.symbols.size, pch = group.symbols, col = "darkblue")
       },
    key = list(space = "top", 
    text = list(group.labels,col = "black"),
    points = list(pch = group.symbols, cex = group.symbols.size, 
    col = "darkblue")))

# attendance by Opponent and day/night game
group.labels <- c("Day","Night")
group.symbols <- c(1,20)
group.symbols.size <- c(2,2.75)
bwplot(Team ~ Attend/1000, data = dodgers, groups = Night, 
    xlab = "Attendance (thousands)",
    panel = function(x, y, groups, subscripts, ...) 
       {panel.grid(h = (length(levels(dodgers$Opponent)) - 1), v = -1)
        panel.stripplot(x, y, groups = groups, subscripts = subscripts, 
        cex = group.symbols.size, pch = group.symbols, col = "darkblue")
       },
    key = list(space = "top", 
    text = list(group.labels,col = "black"),
    points = list(pch = group.symbols, cex = group.symbols.size, 
    col = "darkblue")))

# employ a training-and-test regimen
set.seed(1234) # set seed for repeatability of training-and-test split
training_test <- c(rep(1,length=trunc((2/3)*nrow(dodgers))),
rep(2,length=(nrow(dodgers) - trunc((2/3)*nrow(dodgers)))))
dodgers$training_test <- sample(training_test) # random permutation 
dodgers$training_test <- factor(dodgers$training_test, 
  levels=c(1,2), labels=c("TRAIN","TEST"))
dodgers.train <- subset(dodgers, training_test == "TRAIN")
print(str(dodgers.train)) # check training data frame
dodgers.test <- subset(dodgers, training_test == "TEST")
print(str(dodgers.test)) # check test data frame

#####
# Fitting a linear model
#Multiple Regression
multiple.r.train <- lm(Attend ~ Year+ Team + Month + Day + DayofWeek + Opponent + Temp + 
TypeOfDay + Night + BobbleHd + Headgear + Shirts + Firewks, data=dodgers.train)
summary(multiple.r.train)
confint(multiple.r.train) # compute confidence intervals for regression coefficients
Anova(multiple.r.train) # Anova with type II sum of squares from car package
vif(multiple.r.train) # variance inflation factors with car package vif() function
r.rmse <- sqrt(mean(multiple.r.train$residuals^2)) # Root Mean Square Error Calculation
print (r.rmse) # I will compare this to the other models.

#Testing the data on the test set
dodgers.test$predAttend <- predict(multiple.r.train, newdata = dodgers.test)

dodgers.test$residuals <- dodgers.test$Attend - dodgers.test$predAttend

test.r.rmse <- sqrt(mean(dodgers.test$residuals^2)) # Root Mean Square Error Calculation
print (test.r.rmse) # provides test performance measure to compare with other models 

#I now want to use stepwise to eliminate burdonsome variables
# --------------------------------------------------------------------------
# (1) stepwise regression

# stepwise regression using MASS stepAIC Venables and Ripley (2002, 177-178)
# this program goes from the upper model to the lower model
# dropping one term at a time based upon Akaike's AIC
upper.lm.model <- lm(Attend ~ Year+ Team + Month + Day + DayofWeek + Opponent + Temp + 
TypeOfDay + Night + BobbleHd + Headgear + Shirts + Firewks, data=dodgers.train)

lower.lm.model <- lm(Attend ~ 1,data=dodgers) # intercept only model

stepwise.lm.model <- stepAIC(upper.lm.model,lower.lm.model,trace=T)

confint(lower.lm.model) # compute confidence intervals for regression coefficients
Anova(lower.lm.model) # Anova with type II sum of squares from car package
vif(lower.lm.model) # variance inflation factors with car package vif() function
r.rmse1 <- sqrt(mean(lower.lm.model$residuals^2)) # Root Mean Square Error Calculation
print (r.rmse1) # I will compare this to the other models.

#Testing the data on the test set
dodgers.test$predAttend <- predict(lower.lm.model, newdata = dodgers.test)

dodgers.test$residuals <- dodgers.test$Attend - dodgers.test$predAttend

test.r.rmse2 <- sqrt(mean(dodgers.test$residuals^2)) # Root Mean Square Error Calculation
print (test.r.rmse2) # provides test performance measure to compare with other models 

summary (stepwise.lm.model)

# --------------------------------------------------------------------------
# Hierarchial Model 

# Team as the Hierarchy 
#These are the variables that can be used
group.Team <- groupedData(Attend ~ Day + Temp + Night| Team, data = dodgers) 
group.Team.train <- subset(group.Team, subset = (training_test == "TRAIN"))
group.Team.test <- subset(group.Team, subset = (training_test == "TEST"))

# employ training/test regimen with lme from package nlme
my.lme.train.fit <- lme(group.Team.train)
coef(my.lme.train.fit) # show the fitted coefficients 
group.Team.test$lme_pred_price <- predict(my.lme.train.fit, newdata = group.Team.test)
with(group.Team.test,cor(Attend,lme_pred_price)^2) # R-squared in test set

#RMSE
dodgers.test$predAttend <- predict(my.lme.train.fit, newdata = dodgers.test)

dodgers.test$residuals <- dodgers.test$Attend - dodgers.test$predAttend

test.r.rmse2 <- sqrt(mean(dodgers.test$residuals^2)) # Root Mean Square Error Calculation
print (test.r.rmse2) # provides test performance measure to compare with other models 

summary (stepwise.lm.model)

### Month as the Hierarchy 
group.Team <- groupedData(Attend ~ Day + Temp + Night | Month, data = dodgers) 
group.Team.train <- subset(group.Team, subset = (training_test == "TRAIN"))
group.Team.test <- subset(group.Team, subset = (training_test == "TEST"))

# employ training/test regimen with lme from package nlme
my.lme.train.fit <- lme(group.Team.train)
coef(my.lme.train.fit) # show the fitted coefficients 
group.Team.test$lme_pred_price <- predict(my.lme.train.fit, newdata = group.Team.test)
with(group.Team.test,cor(Attend,lme_pred_price)^2) # R-squared in test set

### Day of Week as the Hierarchy 
group.Team <- groupedData(Attend ~ Day + Temp + Night | DayofWeek, data = dodgers) 
group.Team.train <- subset(group.Team, subset = (training_test == "TRAIN"))
group.Team.test <- subset(group.Team, subset = (training_test == "TEST"))

# employ training/test regimen with lme from package nlme
my.lme.train.fit <- lme(group.Team.train)
coef(my.lme.train.fit) # show the fitted coefficients 
group.Team.test$lme_pred_price <- predict(my.lme.train.fit, newdata = group.Team.test)
with(group.Team.test,cor(Attend,lme_pred_price)^2) # R-squared in test set

### Opponent as the Hierarchy 
group.Team <- groupedData(Attend ~ Day + Temp + Night | Opponent , data = dodgers) 
group.Team.train <- subset(group.Team, subset = (training_test == "TRAIN"))
group.Team.test <- subset(group.Team, subset = (training_test == "TEST"))

# employ training/test regimen with lme from package nlme
my.lme.train.fit <- lme(group.Team.train)
coef(my.lme.train.fit) # show the fitted coefficients 
group.Team.test$lme_pred_price <- predict(my.lme.train.fit, newdata = group.Team.test)
with(group.Team.test,cor(Attend,lme_pred_price)^2) # R-squared in test set

### TypeOfDay as the Hierarchy 
group.Team <- groupedData(Attend ~ Day + Temp + Night | TypeOfDay , data = dodgers) 
group.Team.train <- subset(group.Team, subset = (training_test == "TRAIN"))
group.Team.test <- subset(group.Team, subset = (training_test == "TEST"))

# employ training/test regimen with lme from package nlme
my.lme.train.fit <- lme(group.Team.train)
coef(my.lme.train.fit) # show the fitted coefficients 
group.Team.test$lme_pred_price <- predict(my.lme.train.fit, newdata = group.Team.test)
with(group.Team.test,cor(Attend,lme_pred_price)^2) # R-squared in test set

### Promotion as the Hierarchy 
group.Team <- groupedData(Attend ~ Day + Temp + Night | Promotion, data = dodgers) 
group.Team.train <- subset(group.Team, subset = (training_test == "TRAIN"))
group.Team.test <- subset(group.Team, subset = (training_test == "TEST"))

# employ training/test regimen with lme from package nlme
my.lme.train.fit <- lme(group.Team.train)
coef(my.lme.train.fit) # show the fitted coefficients 
group.Team.test$lme_pred_price <- predict(my.lme.train.fit, newdata = group.Team.test)
with(group.Team.test,cor(Attend,lme_pred_price)^2) # R-squared in test set

#Taking the best hiearchy of Team and using promotion with the other variables 
best <- lme(Attend~ 1 + Month + DayofWeek + Opponent + Temp + TypeOfDay + 
Night + Promotion, data = group.Team.train, random = ~ 1 + Promotion|Team)
coef(best) # show the fitted coefficients
summary(best)
group.Team.test$lme_pred_price <- predict(best, newdata = group.Team.test)
with(group.Team.test,cor(Attend,lme_pred_price)^2) # R-squared in test set


best <- lme(Attend ~ 1 + Team + Month + DayofWeek + Opponent + Night + 
 BobbleHd + Headgear + Shirts + Firewks, data = group.Team.train,  random = ~ 1 + Promotion|Team)
coef(best) # show the fitted coefficients
summary(best)
group.Team.test$lme_pred_price <- predict(best, newdata = group.Team.test)
with(group.Team.test,cor(Attend,lme_pred_price)^2) # R-squared in test set

#RMSE
dodgers.test$predAttend <- predict(best, newdata = dodgers.test)

dodgers.test$residuals <- dodgers.test$Attend - dodgers.test$predAttend

test.r.rmse2 <- sqrt(mean(dodgers.test$residuals^2)) # Root Mean Square Error Calculation
print (test.r.rmse2) # provides test performance measure to compare with other models 













