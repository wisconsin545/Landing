#Prusinski A2 Solo, RWeka 
install.packages(RWeka)
library (RWeka)
#Change Directory First
wekadiamonds <- read.arff("diamonds.arff")
# This is using a M5P classifier 
m1 <- M5P(price ~ carat + color, data = diamonds)
summary(m1)
