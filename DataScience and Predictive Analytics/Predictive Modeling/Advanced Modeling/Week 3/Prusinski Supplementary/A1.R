# Prusinski, Daniel: Assignment 1- Statistical Graphics in R

 library(MMST)
 data(wine)
# This statement accesses the datatset for this assignment.
 str(wine)
# This function gives a helpful metadata statement for the dataset.
 summary(wine)
# This numerical output is helpful, but a visualization would be better. 
 plot(wine)
# This function plotted all the variables against one another. 
#
# While there is not a discernable patter, it can be seen preliminarily that
# a few of the variables are correlated with one another. 
x <- c(wine$Phenols)
y <- c(wine$Flav)
plot(x,y)
# This produces a single scatter plot of Phenols vs Flav.
par(las = 1)
# Tick Marks
plot(x,y,xlab="Phenols",ylab="Flav")
# Labeling Axis'
abline(reg = lm(y ~ x),col="red")
#regression line
title("Scatter Plot of Phenols vs Flav")
# Title
points(x[110],y[110],pch=20)
# Let's just say it took me a while to find that outlier
Arrows(x[110]-.15,y[110],x[110]-1,y[110],code=1)
text(x[110]-1,y[110],pos=2,labels=c("Outlier?"))
# This too took a while to figure out how to place the arrow in correlation
# to the point.

# This next portion of code is creating a histogram and density plot
hist(y)
plot(density(y))
#This is similar to the distribution of Flav

#This portion of code looks at creating a matrix of scatter plots.
x <- c(wine$Phenols)
y <- c(wine$Flav)
z <- c(wine$Ash)
plot (xyz.data)
title("Scatter Plot of Phenols, Flav, Ash")
# As one can see, there is little correlation with Ash.

#I am trying to create a matrix of Density Plots
# one of the uses of the par function is to set up arrangements of plots in rows and columns
par(mfrow=c(3,3))
# first row three columns for x
plot(0,0,xlim=c(-1,1),ylim=c(-1,1),type="n",bty="n",xaxt="n",yaxt="n",pch="n",xlab="",ylab="") # sets up plot area only
plot (d)
plot (e)
plot (f)

par(mfrow=c(3,3))
# first row three columns for x
plot(0,0,xlim=c(-1,1),ylim=c(-1,1),type="n",bty="n",xaxt="n",yaxt="n",pch="n",xlab="",ylab="") # sets up plot area only
plot (d)
plot (e)
plot (f)
#This did not work and I spent over 1 hour trying to get this to work, new approach


#Below is another way to density
Alco <- density(wine$Alcohol)
Ma <- density(wine$MalicAcid)
As <- density(wine$Ash)
AlcAs <- density(wine$AlcAsh)
Mg <- density(wine$Mg)
Ph <- density(wine$Phenols)
Fl <- density(wine$Flav)
NFP <- density(wine$NonFlavPhenols)
Proa <- density(wine$Proa)
Co <- density(wine$Color)
Hu <- density(wine$Hue)
Od <- density(wine$OD)
Prol <- density(wine$Proline)
#These two will not work based on the ternary values
CD <- density(wine$classdigit)
Cl <- density(wine$class)

#Lets try the layout function
layout(matrix(c(1,2,3,4), 2, 2, byrow = TRUE))
plot (Alco)
polygon(Alco, col="red", border="blue")
plot (Ma)
polygon(Ma, col="red", border="blue")
plot (As)
polygon(As, col="red", border="blue")
plot (AlcAs)
polygon(AlcAs, col="red", border="blue")

layout(matrix(c(1,2,3,4), 2, 2, byrow = TRUE))
plot (Mg)
polygon(Mg, col="red", border="blue")
plot (Ph)
polygon(Ph, col="red", border="blue")
plot (Fl)
polygon(Fl, col="red", border="blue")
plot (NFP)
polygon(NFP, col="red", border="blue")

layout(matrix(c(1,2,3,4), 2, 2, byrow = TRUE))
plot (Proa)
polygon(Proa, col="red", border="blue")
plot (Co)
polygon(Co, col="red", border="blue")
plot (Hu)
polygon(Hu, col="red", border="blue")
plot (Od)
polygon(Od, col="red", border="blue")

layout(matrix(c(1), 1, 1, byrow = TRUE))
plot (Prol)
polygon(Prol, col="red", border="blue")


#We will now look at using the lattice package
 xyplot(jitter(Flav) ~ jitter(Phenols),
data = wine,
aspect = 1, 
        layout = c(3, 2),
        strip=function(...) strip.default(..., style=1),
        xlab = "Size or Weight of Diamond (carats)", 
        ylab = "Price")

 xyplot(jitter(Flav) ~ jitter(Phenols),
data = wine,
aspect = 1, 
        layout = c(1, 1),
        strip=function(...) strip.default(..., style=1),
        xlab = "Flav)", 
        ylab = "Phenols")


#Adding more variables
 xyplot(jitter(Flav) ~ jitter(Phenols)  | class, 
data = wine,
aspect = 1, 
        layout = c(3, 3),
        strip=function(...) strip.default(..., style=1),
        xlab = "Size or Weight of Diamond (carats)", 
        ylab = "Price")

#Correlation Coefficient for variables
 x <-(wine$Ash)
> Y <-(Wine$Flav)
Error: object 'Wine' not found
> y <- (wine$Flav)
> cor(x,y)
[1] 0.1150773

# I will add box plots and correlation coefficients as the last part. 


 
 