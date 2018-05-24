# R Tutorial 5: Statistical Graphics

# --------------------------------------------------------------------------
# standard R graphics and the plot function... object-oriented 
x <- c(1,2,3,7,9,8,9)
plot(x) # produces an index plot

y <- c(3,4,6,9,10,9,5)
plot(x,y) # produces a scatterplot

# label the axes using arguments to plot
plot(x,y,xlab="X Variable Label",ylab="Y Variable Label")

# set graphics parameters to set tick labels horizontal
par(las = 1)
plot(x,y,xlab="X Variable Label",ylab="Y Variable Label")

# add a regression line to the plot
abline(reg = lm(y ~ x),col="red")

# add a title
title("Our Little Scatterplot Example")

# replot the unusual point with solid circle
points(x[7],y[7],pch=19) 

# add a horizontal line pointing to the unusual point
segments(x[7]-.15,y[7],x[7]-1,y[7])

# add text to the left of the line
text(x[7]-1,y[7],pos=2,labels=c("Outlier?"))

# suppose we would rather have an arrowhead at the end of the line
# package shape has an arrows fuction
library(shape)
plot(x,y,xlab="X Variable Label",ylab="Y Variable Label")
abline(reg = lm(y ~ x),col="red")
title("Our Little Scatterplot Example")
points(x[7],y[7],pch=19) 
Arrows(x[7]-.4,y[7],x[7]-1,y[7],code=1)
text(x[7]-1,y[7],pos=2,labels=c("Outlier?"))

# standard graphics may be used for scattersmooths and density plots
# as well as many of the standard graphical summaries we might want
# histograms, bar charts, ....
set.seed(777)
x <- rnorm(100,mean=10,sd=1)
hist(x)
plot(density(x))
y <- x + rnorm(100,mean=0,sd=1)
hist(y)
plot(density(y))
scatter.smooth(x,y,las=1) # here we use a par graphics parameter inside the function 

z <- rnorm(100,mean=10,sd=2)
xyz.data <- data.frame(x,y,z)
plot(xyz.data) # here the object being plotted is a data frame... so we get a scatterplot matrix

# one of the uses of the par function is to set up arrangements of plots in rows and columns
par(mfrow=c(3,3))
# first row three columns for x
plot(0,0,xlim=c(-1,1),ylim=c(-1,1),type="n",bty="n",xaxt="n",yaxt="n",pch="n",xlab="",ylab="") # sets up plot area only
text(0,0,label="x",cex=5) # prints letter in center of that plot area
hist(x)
par(mfrow=c(3,3))
# first row three columns for x
plot(0,0,xlim=c(-1,1),ylim=c(-1,1),type="n",bty="n",xaxt="n",yaxt="n",pch="n",xlab="",ylab="") # sets up plot area only
text(0,0,label="x",cex=5) # prints letter in center of that plot area
hist(x)
# second row three columns for y
plot(0,0,xlim=c(-1,1),ylim=c(-1,1),type="n",bty="n",xaxt="n",yaxt="n",pch="n",xlab="",ylab="") # sets up plot area only
text(0,0,label="y",cex=5) # prints letter in center of that plot area
hist(y)
plot(density(y))
# third row three columns for z
plot(0,0,xlim=c(-1,1),ylim=c(-1,1),type="n",bty="n",xaxt="n",yaxt="n",pch="n",xlab="",ylab="") # sets up plot area only
text(0,0,label="z",cex=5) # prints letter in center of that plot area
hist(z)
plot(density(z))

par(mfrow=c(1,1)) # return to a single plotting region 

# there are many graphics packages that build upon standard plotting in R
# diagram is a general drawing utility for network diagrams and flow charts

# maps can be made with maps, plotGoogleMaps, and RgoogleMaps
library(maps)
map("county","california")



# the grid package builds upon standard plotting in R 
# and the lattice and ggplot2 packages, in turn, build grid
# CRAN Task View: Graphic Displays & Dynamic Graphics & Graphic Devices & Visualization 
# http://cran.r-project.org/web/views/Graphics.html

# --------------------------------------------------------------------------
# Comparative Scatterplots with lattice 
# Sample R program to begin work on the Two Month's Salary case study

# read in data from comma-delimited text file
diamonds <- read.csv("R005_two_months_salary.csv")

# install the lattice graphics package prior to using the library() function

library(lattice) # required for the xyplot() function

# let's prepare a graphical summary of the diamonds data
# we note that price and carat are numeric variables with a strong relationship
# also cut and channel are factor variables related to price
# showing the relationship between price and carat, while conditioning
# on cut and channel provides a convenient view of the diamonds data
# in addition, we jitter to show all points in the data frame

xyplot(jitter(price) ~ jitter(carat) | channel + cut, 
       data = diamonds,
        aspect = 1, 
        layout = c(3, 2),
        strip=function(...) strip.default(..., style=1),
        xlab = "Size or Weight of Diamond (carats)", 
        ylab = "Price")
        
# to output this plot as a pdf file we use the pdf() function and close with dev.off()
pdf("R005_plot_diamonds_lattice.pdf",width=11,height=8.5)
xyplot(jitter(price) ~ jitter(carat) | channel + cut, 
       data = diamonds,
        aspect = 1, 
        layout = c(3, 2),
        strip=function(...) strip.default(..., style=1),
        xlab = "Size or Weight of Diamond (carats)", 
        ylab = "Price")
 dev.off()
 

# --------------------------------------------------------------------------
# Correlation Matrix Heatmap with lattice

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

# next print to an Adobe Acrobat pdf file
pdf(file="R005_plot_correlation_heat_map.pdf",width=11,height=8.5)
levelplot(ordered.bodyfat.cormat,col.regions=colorRampPalette(c("red", "white", "blue")), xlab=NULL, ylab=NULL, scales=list(tck=0, x=list(rot=90)), main="Correlation Levelplot for Bodyfat Data")
dev.off()


# --------------------------------------------------------------------------
# Multiple Time Series with standard graphics
# and Horizon Plot with latticeExtra

financial.data.frame <- read.csv("R005_financial_time_series.csv")

financial.data.frame$Assets <- financial.data.frame$CurrentAssets + financial.data.frame$FixedAssets

financial.data.frame$Profit <- financial.data.frame$MonthlyRevenue - financial.data.frame$MonthlyExpenses

financial.data.frame$ReturnOnAssets <- financial.data.frame$Profit/financial.data.frame$Assets

financial.data.frame$ReturnOnEquity <- financial.data.frame$Profit/financial.data.frame$Equity

financial.data.frame$ProfitMargin <- financial.data.frame$Profit/financial.data.frame$MonthlyRevenue

financial.data.frame$EquityAssetsRatio <- financial.data.frame$Equity/financial.data.frame$Assets

financial.data.frame$EquityAssetsIndicator <- financial.data.frame$EquityAssetsRatio - 0.5

# create multivariate time series
financial.mts <- as.matrix(financial.data.frame[,c("ReturnOnAssets","ReturnOnEquity","ProfitMargin","EquityAssetsIndicator")])

# create multiple time series object with date information as part of the object
mts.dat <- ts(financial.mts,start = c(2005,7),frequency = 12)
colnames(mts.dat) <- c("Return on Assets","Return on Equity","Profit Margin","Equity/Assets > 0.5")

# suppose we use standard graphics to plot this multiple time series
plot.ts(mts.dat,main="Standard Graphics for a Multiple Time Series")

# lets try to make a horizon plot for this multiple time series
library(latticeExtra) # install this package prior to running the program

# use ylab rather than strip.left, for readability.
# also shade any times with missing data values.
# first print to the screen
print(horizonplot(mts.dat, horizonscale = .05, colorkey = TRUE,
            layout = c(1,4), strip.left = FALSE, origin = 0,
            ylab = list(rev(colnames(mts.dat)), rot = 0, cex = 0.7)) +
  layer_(panel.fill(col = "gray90"), panel.xblocks(..., col = "white")))
  
# next print to an Adobe Acrobat pdf file
pdf(file="R005_plot_financial_horizon.pdf",width=11,height=8.5)
print(horizonplot(mts.dat, horizonscale = .05, colorkey = TRUE,
            layout = c(1,4), strip.left = FALSE, origin = 0,
            ylab = list(rev(colnames(mts.dat)), rot = 0, cex = 0.7)) +
  layer_(panel.fill(col = "gray90"), panel.xblocks(..., col = "white")))
  
dev.off()  


# --------------------------------------------------------------------------
# comparative density plots ggplot2 graphics and transparency overplotting
library(ggplot2)

set.seed(7777)
value <- rnorm(100000,mean=100,sd=20)
FirstSet <- data.frame(value,Group = rep("First Set",length=length(value)))
value <- rnorm(100000,mean=120,sd=25)
SecondSet <- data.frame(value,Group = rep("Second Set",length=length(value)))
BothSets <- rbind(FirstSet,SecondSet)
BothSets$Group <- factor(BothSets$Group)

# quick plotting with qplot under ggplot2 
qplot(value, data=BothSets, geom = "density", fill = Group, alpha = I(0.2))

# not so quick, but more versatile is to build up a ggplot object
ggplot_object <- ggplot(data = BothSets, aes(x = value)) + geom_density(data=FirstSet,aes(ymax = ..density..,ymin = -..density..), fill = "red",alpha = I(0.2), xlim=c(0,250), position="identity") + geom_density(data=SecondSet,aes(ymax = ..density..,ymin = -..density..), fill = "blue",alpha = I(0.2), xlim=c(0,250), position="identity")
print(ggplot_object)

# send the plot to an external pdf file
pdf(file="R005_plot_overlapping_densities.pdf",width=11,height=8.5)
print(ggplot_object) 
dev.off()

# --------------------------------------------------------------------------
# map making example with ggplot2 graphics

library(ggplot2)
library(ggmap)

# Madison/Dane County target bounding box specification longitude and latitude values
target.left <- -89.63
target.right <- -89.23
target.top <- 43.24
target.bottom <- 42.95

# get the road map from Google
madison_map <- get_map(location =c(target.left,target.bottom,target.right,target.top), zoom = 12, scale = "auto", maptype = c("roadmap"), messaging = FALSE, urlonly = FALSE, filename = "R005_plot_madison_map_start", crop = TRUE, color = c("color"), source = c("google")) 

# plot the map that has been retrieved from Google
ggmap(madison_map) 

# determine the actual bounding box set by Google
actual.bounding.box <- unlist(attributes(madison_map)[3])
actual.bottom <- as.numeric(actual.bounding.box[1])
actual.left <- as.numeric(actual.bounding.box[2])
actual.top <- as.numeric(actual.bounding.box[3])
actual.right <- as.numeric(actual.bounding.box[4])

# use the result of ggmap as a base ggplot2 plotting object
madison_map_ggplot_object <- ggmap(madison_map) 

# let's embellish the map by adding ggplot2 attributes to the ggplot object
madison_map_ggplot_object <- madison_map_ggplot_object + labs(list(x="East-West Coordinate (Longitude)",y="North-South Coordinate (Latitude)",fill="")) 
print(madison_map_ggplot_object) 

# suppose we want to see the latitude and longitude values with end points identified
madison_map_ggplot_object <- madison_map_ggplot_object + scale_x_continuous(breaks = seq(actual.left,actual.right,length.out=5),labels=format(seq(actual.left,actual.right,length.out=5),digits=4)) + scale_y_continuous(breaks = seq(actual.bottom,actual.top,length.out=5), labels=format(seq(actual.bottom,actual.top,length.out=5),digits=4)) 
print(madison_map_ggplot_object) 

# add a point to the map corresponding to longitude and latitude 
tom.in.madison <- data.frame(lon=-89.37752,lat=43.086034)
madison_map_ggplot_object <- madison_map_ggplot_object + geom_point(data=tom.in.madison,size=2)  
print(madison_map_ggplot_object) 

# add text annotation just to the left of the added point
madison_map_ggplot_object <- madison_map_ggplot_object + geom_text(data = {tom.in.madison - c(+0.008,0)},label="TOM",size=3) 
print(madison_map_ggplot_object) 

# send the plot to an external pdf file
pdf(file="R005_plot_madison_map.pdf",width=11,height=8.5)
print(madison_map_ggplot_object) 
dev.off()

# --------------------------------------------------------------------------
# another example with ggplot2 graphics... just the output this time
# a ribbon plot dashboard for managing taxi services day-by-day
# see file R005_plot_ribbon_dashboard_example.pdf


