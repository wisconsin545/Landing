# jumpstart program to read in bobbleheads data and define new Promotion variable

# run the entire program by typing 
#  source("450_assignment1_jump_start_v002.R")

all.teams.data.frame <- read.csv(file = "bobbleheads_v002.csv")

# examine the data frame for all teams
print(str(all.teams.data.frame))

# create summary giveaway promotions variable
# ignore fireworks promotions as they are only at night games
# also some teams like the Dodgers use fireworks on special days only 
# such as Fridays and 4th of July weekend
all.teams.data.frame$Promotion_Sum <- all.teams.data.frame$BobbleHd + 
  all.teams.data.frame$Headgear + 
  all.teams.data.frame$Shirts

# construct an any promotion factor with labels
all.teams.data.frame$Promotion <- ifelse((all.teams.data.frame$Promotion_Sum == 0),0,1)
all.teams.data.frame$Promotion <-   factor(all.teams.data.frame$Promotion, 
  levels = c(0,1), labels = c("NO","YES"))

# set labels for the BobbleHd factor variable
all.teams.data.frame$BobbleHd <- 
  factor(all.teams.data.frame$BobbleHd, 
  levels = c(0,1), labels = c("NO","YES"))

# set labels for the Headgear factor variable
all.teams.data.frame$Headgear <- 
  factor(all.teams.data.frame$Headgear, 
  levels = c(0,1), labels = c("NO","YES"))
  
# set labels for the Shirts factor variable
all.teams.data.frame$Shirts <- 
  factor(all.teams.data.frame$Shirts, 
  levels = c(0,1), labels = c("NO","YES"))
  
# examine the data frame for all teams
print(str(all.teams.data.frame))  

# examine the first six records of promotion data for all teams
print(head(all.teams.data.frame[,c("Team","BobbleHd","Headgear","Shirts","Promotion")]))  

# examine the last six records of promotion data for all teams
print(tail(all.teams.data.frame[,c("Team","BobbleHd","Headgear","Shirts","Promotion")]))

# see the extent of any promotion used by teams
with(all.teams.data.frame, print(table(Team, Promotion)))

# select the Dodgers as home team to check on the calculations for Promotion
dodgers.data.frame <- subset(all.teams.data.frame,
  subset = (Team == "Los Angeles Dodgers"))
print(dodgers.data.frame[,c("Opponent","BobbleHd","Headgear","Shirts","Promotion")])
  