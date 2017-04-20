
rm(list=ls())

# Load all the packages required for this assignment #
packages <- c("ggplot2","tidyr","dplyr","ggthemes")
purrr::walk(packages, library, character.only = TRUE, warn.conflicts = FALSE); rm(packages)

# Loading the Data #
link = 'https://data.cityofnewyork.us/api/views/h9gi-nx95/rows.csv?accessType=DOWNLOAD'
df<-read.csv(url(link),na.strings=c("","NA"))

# Cleaning the Date Format #
df$DATE <- as.Date(df$DATE,format='%m/%d/%Y')
df = df[df$DATE>='2013/01/01',]
df = df[df$DATE<'2017/01/01',]
df = df[order(df$DATE),]


# Getting Missing Data #
na_perc = as.data.frame(100* apply(df, 2, function(col)sum(is.na(col))/length(col)))
na_perc$Var = rownames(na_perc)
colnames(na_perc) = c("NA_Percentage","Variables")
na_perc <- na_perc[order(na_perc$NA_Percentage),]

# Plotting the Missing data #
plot = ggplot(na_perc,aes(y= NA_Percentage, x=reorder( Variables,NA_Percentage)))
plot + geom_bar( stat="identity", position = "dodge", fill ="firebrick4")+coord_flip()+ theme_economist() + scale_colour_economist() +
  scale_y_continuous()+ ggtitle("Percentage of Missing Values in NYC Vehicle Collisions Dataset \nby Variable Type") +ylab("Missing Value Percentage") + xlab("Variables")+ theme(plot.title=element_text(hjust=0.5),title=element_text(size=16, face="italic",colour = "black"))

