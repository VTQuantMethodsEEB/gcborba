# assignment 2 data_manipulation  


#load important packages##
library(tidyverse)
library(tidyr)
library(dplyr)

#2. Input your data into R. ####
#using the catch data - read
catdat=read.csv("catch_data.csv") 

head(catdat)  
unique(catdat$spp)
hist(catdat$catch)

catdat$lgdL=log10(catdat$catch)#log the catch fish 
catcounts<-aggregate(catch~spp+river+date,data=catdata, FUN=mean)  #make a df of cat counts


##how to use base R's match##
catloads<-aggregate(lgdL~spp+river+date,data=catdat, FUN=mean)  #make a df of cat loads


#1. Put your data in tidy format####
cat.wide <- catdat %>% #this says - make a new df called cat.wide 
  pivot_wider(names_from = spp, values_from = catch) 
##make columns for each of the values in the species column and fill those columns with values from the count column

View(cat.wide)
#3.Examine your data for mistakes####
#rename river 
str(catdat)
unique(catdat$river)

catdat <- catdat %>% 
  mutate(river = recode(river, "NEGRO" = "neg"))
catdat$river <- factor(catdat$river)
#4. Experiment with “group by” in dplyr to do some calculation####

## Group by, Mutate, and Summarise
catdat %>% 
  group_by(spp) %>% 
  summarise(mean.catch=mean(catch,na.rm=TRUE))
#this gives you a summary table, it doesn't change catdat

#creating a new summary (mean) table
cat.load.table = catdat %>% 
  group_by(river,spp,date) %>% 
  summarise(mean.catch=mean(catch,na.rm=TRUE))

cat.load.table

#5. Use mutate and summarise on your data####
#How are these different? Annotate your code to explain. 
##Summarise versus Mutate
catdat_with_sample_size = catdat %>% 
  #create a new dataframe  
  group_by(river,spp,date) %>% 
  #you can group_by multiple things
  mutate(mean.catch=mean(catch,na.rm=TRUE))
#this adds a column to the dataframe
catdat_with_sample_size

##we could have also just added this column to batdat
cattdat = catdat %>% 
  #create a new dataframe  called batdat_with_sample_size
  group_by(river,spp,date) %>% 
  #you can group_by multiple things
  mutate(sample.size=length(date))
#this adds a column to the dataframe
catdat

#Answer: mutate add a new variable and preserves existing ones while summarise 
#creates a new data frame just with the grouping variables. 


#6. Commit and push to GitHub. Be sure to update your README!
#Script and README upload to GitHub

