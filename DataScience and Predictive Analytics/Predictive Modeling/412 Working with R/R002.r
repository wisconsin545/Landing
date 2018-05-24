ls()

# random numbers

runif(100)

my.runif <- runif(100)

ls()

str(my.runif)

rnorm(100)

hist(runif(1000))

hist(runif(10000))

hist(runif(100000))

hist(runif(1000000))

plot(density(rnorm(1000000)),xlim=c(-5,5))

rnorm(10)
rnorm(10)
rnorm(10)

set.seed(9999)
rnorm(10)

set.seed(9999)
rnorm(10)

set.seed(9999)
rnorm(10)


# sampling

set.seed(9999)
sample(c(1,2,3,4,5,6,7,8,9)) # random permutation

set.seed(9999)
permute.list <- sample(c(1,2,3,4,5,6,7,8,9))

learn.list <- permute.list[1:5]

test.list <- permute.list[6:9]

set.seed(9999)
sample(c(1,2,3,4,5,6,7,8,9),5,replace=FALSE) # random sample without replacement

set.seed(9999)
sample(c(1,2,3,4,5,6,7,8,9),5,replace=TRUE) # random sample with replacement

set.seed(9999)
sample(c(1,2,3,4,5,6,7,8,9),30,replace=TRUE) # random sample with replacement

set.seed(9999)
hist(sample(c(1,2,3,4,5,6,7,8,9),30,replace=TRUE))


# work with dataframe

library(MMST)
data(bodyfat)

# print(bodyfat) # would be long listing

str(bodyfat)

head(bodyfat)

names(bodyfat)

mean(bodyfat$hip)

attributes(bodyfat)

ncol(bodyfat)

nrow(bodyfat)

class(bodyfat)

(class(bodyfat) == "data.frame")

as.numeric((class(bodyfat) == "data.frame"))

sapply(bodyfat,mean)

sapply(bodyfat,median)

percentile.90 <- function(x) 
  { # begin user-defined function
  quantile(x,probs=c(0.90))
  } # begin user-defined function

sapply(bodyfat,FUN=percentile.90)

summary(bodyfat)

plot(bodyfat,cex=0.1)

pdf(file="bodyfat_scatter_matrix.pdf",width = 11,height=8.5)
plot(bodyfat,cex=0.5)
dev.off()

pdf(file="wine_scatter_matrix.pdf",width = 11,height=8.5)
plot(wine,cex=0.5)
dev.off()

my.model <- lm(bodyfat ~ weight + neck, data=bodyfat)

#wine

wine.model <- lm(Alcohol ~ MalicAcid + Ash, data=wine)

str(my.model)

my.model

#this does the same thing as my.model
print(my.model)

#this does the same thing as my.model
my.model$coefficients

my.model$residual[1:6]

head(my.model$residuals)
head(wine.model$residuals)

head(bodyfat$bodyfat)
head(Alcohol$Alcohol)

head(predict(my.model))
head(predict(wine.model))

head(my.model$fitted.values)
head(wine.model$fitted.values)

head(bodyfat$bodyfat) - head(predict(my.model))

toms.R.squared <- cor(bodyfat$bodyfat,predict(my.model))^2
dans.R.squared <- cor(Alcohol$Alcohol,predict(wine.model))^2

summary(my.model)
summary(wine.model)

anova(my.model)

plot(my.model)
plot(wine.model)

library(hints)
hints(class="lm")

# open-source extensible environment

my.model

print(my.model)

print.lm(my.model)

print.lm

sink("print_lm_code.r")

print.lm

sink()

source("tom_print_lm_code.r")





