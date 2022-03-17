rm(list=ls())
#loading package used
library(corrplot)
library(car)
library(arm)
library(multcomp)
library(ggplot2)
library(tidyverse)
library(tidyr)
library(dplyr)

#using the catch data - read
catdat=read.csv("catch.csv") 
hyd=read.csv("hydro.csv")

#Make an univariate linear model for one of your hypotheses___####
#H1 = the catch values is significantly higher in larger boat length than smaller boats. 

#Split my boat length data into small and large values 
small<-catdat %>%
  group_by(catch) %>%
  filter(length < mean(length, na.rm = TRUE)) %>%
  summarise(catch,length )

large<-catdat %>%
  group_by(catch) %>%
  filter(length > mean(length, na.rm = TRUE)) %>%
  summarise(catch,length )

#create a new data frame and aggregate boats groups values 
fish <- data.frame(
  length=rep(c("small","large"),
             c(length(small$length), length(large$length))),
  catch=c(small$catch, large$catch)
)
fish


ama=subset(catdat$catch,catdat$length,catdat$river=="amz", na.omit=T)
mad=subset(catdat$catch,catdat$river=="mad")
#H1 = the catch values is significantly different between boat length. 

mod<-lm(catch~length, data=catdat);summary(mod)

#Examine the assumptions of linearity (using tests and diagnostic plots)___####

plot(mod)

hist(resid(mod))
shapiro.test(sample(resid(mod), 500))#get normally by using a sample from my data


#Explain what these are telling you (it’s okay if they aren’t normal, but tell me why)___####


#Plot the relationship in ggplot using stat_smooth or stat_summary___####

r=ggplot(data=catdat, aes(x=length, y=log(catch)))+ 
  geom_point()+
  stat_smooth(method = "lm")+
  theme_bw() + labs(x="Boat length",y="log(catch)")+
  theme(axis.title=element_text(size=20),axis.text=element_text(size=10),
        panel.grid = element_blank(), axis.line=element_line())
        
print(r)

#checking correlation 
corrplot(cor(mtcars[, -1]))