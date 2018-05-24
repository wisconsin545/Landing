# install hints
library(hints)

# can use as a calculator

3 + 5

2000 - 3400

4*7

30/5

pi

sin(pi)

round(sin(pi),digits=9)

curve(sin, -2*pi, 2*pi, xname = "t")

curve(tan, -2*pi, 2*pi, xname = "t")

factorial(3)

factorial(9)

sqrt(49)

5^3


# data structures

y <- c(0,2,4,6)

X <- matrix(data = 1:12, nrow = 4, ncol = 3, byrow = TRUE,dimnames = NULL)

X  

X[1,]

X[,1]

X[1,2]

t(X) 

t(X) %*% X

diag(t(X) %*% X)

diag(5)

det(t(X) %*% X)

# also arrays, lists, data frames


# set functions

A <- c(3,4,5,6,7,8)

3:8

seq(3:8)

seq(along=A)

A

B <- c(3,6,9,12,15)

union(A,B)

intersect(A,B)

setdiff(A,B)

setdiff(B,A)

setequal(A,B)  # returns a logical/Boolean object

as.numeric(setequal(A,B))


# conditional branching

if(setequal(A,B)) cat("A and B are equal sets") else cat("A and B are not equal sets")


# work with dataframe

library(MMST)
data(bodyfat)

# bodyfat print(bodyfat) # would be long listing

str(bodyfat)

head(bodyfat)

summary(bodyfat)

plot(bodyfat,cex=0.1)

hist(bodyfat$bodyfat)

# random numbers

set.seed(9999)
x <- runif(100)
plot(density(x),xlim=c(0,1))

set.seed(9999)
plot(density(runif(1000000)),xlim=c(0,1))

set.seed(9999)
plot(density(rnorm(1000000)),xlim=c(-5,5))


# sampling

set.seed(9999)
sample(c(1,2,3,4,5,6,7,8,9)) # random permutation

sample(c(1,2,3,4,5,6,7,8,9),5,replace=FALSE) # random sample without replacement

sample(c(1,2,3,4,5,6,7,8,9),5,replace=TRUE) # random sample without replacement



