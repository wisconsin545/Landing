# demo get predicted values from hierarchical model
# this program uses the Two Months' Salary Case data
# that we had provided with the Session 4 Programming Assignment
# but here we show how to set things up for a hierarchical model
# for prediction of the price of diamonds...

# the structure of this analyis demonstrates hierarchical modeling
# methods that can be used in in the actual Session 6 modeling problem

library(nlme) # for function lme

diamonds <- read.csv("two_months_salary.csv")

# 2/3 for TRAIN and 1/3 for TEST
TRAIN_TEST <- c(rep("TRAIN", length=trunc(nrow(diamonds)*(2/3))),
    rep("TEST", length = nrow(diamonds) - trunc(nrow(diamonds)*(2/3))))
# randomly associate dataset rows to TRAIN/TEST subsets
set.seed(1234)
diamonds$TRAIN_TEST <- sample(TRAIN_TEST)

# add structure to data frame as needed for lme
# this will provide varying intercepts and slopes by store
group.diamonds <- groupedData(price ~ carat | store, data = diamonds)
group.diamonds.train <- subset(group.diamonds, subset = (TRAIN_TEST == "TRAIN"))
group.diamonds.test <- subset(group.diamonds, subset = (TRAIN_TEST == "TEST"))

# employ training/test regimen with lme from package nlme
my.lme.train.fit <- lme(group.diamonds.train)
coef(my.lme.train.fit) # show the fitted coefficients 
group.diamonds.test$lme_pred_price <- predict(my.lme.train.fit, newdata = group.diamonds.test)
with(group.diamonds.test,cor(price,lme_pred_price)^2) # R-squared in test set

cat("\nThis is the end of the program\n")

# Pinheiro, J. C. & Bates, D. M. (2008). Mixed-effects models in S and S-Plus. New York: Springer.

