# R Input and Output.... using case data from Two Month's Salary case

# ensure that comma-delimited text files do not have problem characters in any fields
# problem characters in a comma-delimited text file are these four: , # ' "

# ensure that factor variables are properly defined for modeling work

# input and output go hand-in-hand with data manipulation and the definition of variable types

# ---------------------------------------------
# two_months_salary.r

# Sample R program to begin work on the Two Month's Salary case study

# to run the entire source code program type:  source("two_months_salary.r")  

# read in data from comma-delimited text file
diamonds <- read.csv("two_months_salary.csv")

cat("\n","----- Initial Structure of diamonds data frame -----","\n")
# examine the structure of the initial data frame
print(str(diamonds))

# we can create a new channel factor called internet as a binary indicator   
# the ifelse() function is a good way to do this type of variable definition
diamonds$internet <- ifelse((diamonds$channel == "Internet"),2,1)
diamonds$internet <- factor(diamonds$internet,levels=c(1,2),labels=c("NO","YES"))

cat("\n","----- Checking the Definition of the internet factor -----","\n")
# check the definition of the internet factor
print(table(diamonds$channel,diamonds$internet))
 
# we might want to transform the response variable price using a log function
diamonds$logprice <- log(diamonds$price)

cat("\n","----- Revised Structure of diamonds data frame -----","\n")
# we check the structure of the diamonds data frame again
print(str(diamonds))
                                                                      
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

pdf("plot_diamonds_lattice.pdf",width=11,height=8.5)
xyplot(jitter(price) ~ jitter(carat) | channel + cut, 
       data = diamonds,
        aspect = 1, 
        layout = c(3, 2),
        strip=function(...) strip.default(..., style=1),
        xlab = "Size or Weight of Diamond (carats)", 
        ylab = "Price")
 dev.off()
 
# having looked at the data, we are ready to begin our modeling work
# we can use the lm() function for linear regression
# predicting price from combinations of explanatory variables
# we can explore variable transformations
 
# for a generalized linear model we might try using the glm() function 
# to predict channel, internet (YES or NO), from price or other variables
# for logistic regression, we would use glm() with family="binomial"

# the modeling methods we employ should make sense for the case study problem
# ---------------------------------------------

# output the expanded diamonds data.frame to a comma-delimited text file
write.csv(diamonds,file="diamonds_data_frame_output.csv")

# another form of output is to save selected objects in a binary file
# object names are listed at the beginning of this function
# an unlimited number of names separated by commas
save(diamonds,file="two_months_salary.Rdata")

# the reverse operation would involve loading the objects
# with load("two_months_salary.Rdata")
# also R binary files are transportable across systems
 
# -------------------------------------------------------
# suppose the input file were two_months_salary_character.csv
# with most variables input as character variables

# note useful functions for defining variable types
# as.numeric()  as.character()  as.integer()  factor()  logical()

temp.diamonds.char <- read.csv("two_months_salary_char.csv")
print(str(temp.diamonds.char))

# by default read.csv will read character string fields as factor variables
# sometimes this is fine... but with the Two Month's Salary case it is not
# so we neen do specify that certain of the columns in the file are to be
# treated as character strings rather than factor variables
# then later we will convert these character strings to numeric
# and finally, for certain of the variables, from numeric to factor
# Why all this fuss? R modeling procedures treat different variable types
# in different ways, as they should. We want to use the full power of R 
# and that means getting our data frames in shape prior to using the
# various modeling functions. Nothing new here. Data preparation is often
# where we spend much of our time.

# lets try reading color and clarity into the data frame as character strings
diamonds.char <- read.csv("two_months_salary_char.csv",colClasses=c("numeric","character","character","factor","factor","factor","numeric"))
print(str(diamonds.char))

# we can name variables in this dataset to conform to the names used in the previous data set
diamonds.char$cut <- diamonds.char$cutchar
diamonds.char$channel <- diamonds.char$channelchar
diamonds.char$store <- diamonds.char$storechar

# we can define the internet factor variable as before
diamonds.char$internet <- ifelse((diamonds.char$channel == "Internet"),2,1)
diamonds.char$internet <- factor(diamonds.char$internet,levels=c(1,2),labels=c("NO","YES"))

print(str(diamonds.char))

# now we want to recode the color and clarity variables 
# so that their meaningful order may be utilized in linear models

# suppose we utilize the recode function from the car package to create numeric variables
# the car package is associated with Fox and Weisberg (2011)

# from the car user manual we see this recode function documentation:
# recode(var, recodes, as.factor.result, as.numeric.result=TRUE, levels)
# Arguments var	numeric vector, character vector, or factor.
# recodes character string of recode specifications: see below.
# as.factor.result return a factor; default is TRUE if var is a factor, FALSE otherwise.
# as.numeric.result	if TRUE (the default), and as.factor.result is FALSE, 
# then the result will be coerced to numeric if all values in the result are numerals—i.e., represent numbers.
# levels an optional argument specifying the order of the levels in the returned factor; 
# the default is to use the sort order of the level names.

library(car)
diamonds.char$color <- recode(diamonds.char$colorchar,"c('D')=1 ;c('E')=2;c('F')=3;c('G')=4;c('H')=5;c('I')=6;c('J')=7;c('K')=8;c('L')=9;c('M')=10")

# let's check to see that this new data frame has the same values for color as the original diamonds data frame
# here we need to utilize the all() function to test that all items of these vectors are equivalent
# see Matloff(2011, pp. 54-55) for an explanation of the vectorized function == and its use with the all() function
if(all(diamonds.char$color == diamonds$color)) cat("\n","the definintion of color in diamonds.char was successful","\n") else cat("\n","the definintion of color in diamonds.char was NOT successful","\n") 

diamonds.char$clarity <- recode(diamonds.char$claritychar,"c('FL')=1 ;c('IF')=2;c('VVS1')=3;c('VVS2')=4;c('VS1')=5;c('VS2')=6;c('SI1')=7;c('SI2')=8;c('I1')=9;c('I2')=10;c('I3')=11")
if(all(diamonds.char$clarity == diamonds$clarity)) cat("\n","the definintion of clarity in diamonds.char was successful","\n") else cat("\n","the definintion of clarity in diamonds.char was NOT successful","\n") 

# to complete the set of variables/columns from the original data frame diamonds
# we transform the response variable price using a log function
# defining a new variable logprice
diamonds.char$logprice <- log(diamonds.char$price)

# we can remove unnecessary variables/columns from the diamonds.char data frame 
# creating a new data frame to test against the original diamonds data frame
# we want only those variables/columns from the diamonds data frame
# note that the list of variables/columns we want is given by names(diamonds)

print(names(diamonds))

diamonds.char.test <- diamonds.char[,names(diamonds)]

print(str(diamonds.char.test))
print(str(diamonds))

# comparing the structure of the two data frames 
# we see only minor differences in numeric versus integer data types
# these are easily fixed using the as.integer function

diamonds.char.test$color <- diamonds.char$color <- as.integer(diamonds.char$color)
diamonds.char.test$clarity <- diamonds.char$clarity <- as.integer(diamonds.char$clarity)
diamonds.char.test$price <- diamonds.char$price <- as.integer(diamonds.char$price)

# note that for variables with meaningful magnitude, it makes 
# little difference whether their type is set to integer or numeric

print(str(diamonds.char.test))

# ----------------------------------------------------------------------
# user-defined function to see if two data frames are equivalent
equivalent.data.frames <- function(frame.a,frame.b)
{ # begin user-defined function to see if two data frames are equivalent

# ensure that both objects are in fact data frames
if(class(frame.a) != "data.frame") return(FALSE)
if(class(frame.b) != "data.frame") return(FALSE)

# ensure that the data frames have identical numbers of variables/columns
if(ncol(frame.a) != ncol(frame.b)) return(FALSE) 

# ensure that the data frames have the same number of rows
if(nrow(frame.a) != nrow(frame.b)) return(FALSE)

# ensure that the data frames have identical
# variables/column names in the same order 
if(!all(names(frame.a) == names(frame.b))) return(FALSE)

logical.return.value <- TRUE # initialize message indicating that the data frames are equivalent

# for-loop for checking vector equivalence of one variable/column name at a time
for(index.for.column in seq(along=names(frame.a)))
   if(!all(frame.a[,index.for.column] == frame.b[,index.for.column])) logical.return.value <- FALSE

return(logical.return.value) # returns logical TRUE or FALSE

} # end user-defined function to see if two data frames are equivalent
# ----------------------------------------------------------------------

# let's test this user-defined function to see if it works

equivalent.data.frames(diamonds,diamonds)

equivalent.data.frames(diamonds,diamonds$cut)

equivalent.data.frames(diamonds,diamonds.char)

equivalent.data.frames(diamonds,diamonds.char.test)

equivalent.data.frames(diamonds,diamonds.char.test[1:10,])

# ----------------------------------------------------------------------
# some examples of subsets of rows or columns from data frames

str(diamonds)

head(diamonds)

diamonds[1:10,]

diamonds[1:10,c("carat","cut","price")]

diamonds[255,c("carat","cut","price")]

table(diamonds$cut)

not.ideal.diamonds <- diamonds[(diamonds$cut=="Not Ideal"),]

nrow(not.ideal.diamonds)

# other very useful functions for working with R objects
# and sorting and merging of data frames
# sort() for vectors
# sort.list() for sorting all columns of a data frame using one column as the key
# cbind() and rbind()

# for the purposes of demonstration we begin by adding an identifier to the cases
diamonds$id <- seq(1:nrow(diamonds))
head(diamonds)

# add a key for dividing a data frame into learning and test
partition <- sample(nrow(diamonds)) # permuted list of index numbers for rows
diamonds$group <- ifelse((partition < nrow(diamonds)/2),1,2)
diamonds$group <- factor(diamonds$group,levels=c(1,2),labels=c("TRAIN","TEST"))

print(table(diamonds$group))

head(diamonds)

diamonds.train <- diamonds[(diamonds$group == "TRAIN"),]
print(str(diamonds.train))

diamonds.test <- diamonds[(diamonds$group == "TEST"),]
print(str(diamonds.test))

intersect(diamonds.train$id,diamonds.test$id)

# putting these back together again
diamonds.merged <- rbind(diamonds.train,diamonds.test)

print(nrow(diamonds.merged))

equivalent.data.frames(diamonds,diamonds.merged)

head(diamonds.merged)

diamonds.merged.sorted <- diamonds.merged[sort.list(diamonds.merged$id,decreasing=FALSE),]

equivalent.data.frames(diamonds,diamonds.merged.sorted)

# -------------------------------------------------------------------------
# R has procedures for working with binary files from other systems
# foreign package to work with Excel SPSS SAS files.... 
# support for SQL databases... see Fox and Weisberg (2011, pp. 53-56)

# -------------------------------------------------------------------------
# Exercise. Begin with a data frame that has all numeric data
# coded as in the case write-up two_months_salary.pdf  ?
# Using the comma-delimited text file: two_months_salary_numeric.csv
# define factor variables as appropriate.
# What happens when you test the equivalence of diamonds and 
# the new data frame that you define from two_months_salary_numeric.csv ?
# --------------------------------------------------------------------------

# References

# Fox, J. & Weisberg, S. (2011). An R companion to applied regression (2nd ed.). Thousand Oaks, CA: Sage. [ISBN-13 978-1412975148]

# Matloff, N. (2011). The art of R programming: A tour of statistical software design. San Francisco, CA: No Starch Press. [ISBN-13: 978-1593273842]

# Pope, B. A. (2006). Two Month's Salary. Madison, WI: Research Publishers. [ISBN10: 1-60147-000-2]

# Spector, P. (2008). Data manipulation in R. New York: Springer. Excellent reference about R input and output. Moving beyond rbind and cbind functions, Phil Spector, provides discussion of merge and aggregate functions. Chapter titles: Data in R, Reading and Writing Data, R and Databases, Dates, Factors, Subscripting, Character Manipulation, Data Aggregation, and Reshaping Data. Moving beyond rbind and cbind functions, Phil Spector, provides discussion of merge and aggregate functions. 
