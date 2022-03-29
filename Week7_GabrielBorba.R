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
library(effects)
#using the catch data - read
catdat=read.csv("catch.csv") 
catdat$river = factor(catdat$river)
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

#log gives me - inf values so I can't go through by using log 
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

#PART 2####

#1. Make a linear model (with more than one variable) for one of your hypotheses. Articulate which hypothesis you are testing.
#Consider the length boat in addition to river sites

#H2 = the fish catch is significantly different for boat length and river sites.

mod1<-lm(catch~length+factor(river), data=catdat);summary(mod1)

#2. Use an interactive model and an additive model. Explain what hypothesis each of these is testing, and what the R output is telling you about your data.
#(Hint: you can use emmeans, effects, relevel, or predict to help you.) You should include this explanation in either your README or in your code.

#H2 = the fish catch depends on length boat and river sites.

mod_inter<-lm(catch~length*river, data=catdat);summary(mod_inter)


summary(allEffects(mod_inter))

#3. Plot your model (e.g. using predict) and overlay the model on top of the underlying data. See code for example to plot both model and data (on github).

#make a new dataframe
new.dat <- with(catdat,
                       expand.grid(river=levels(river), 
                                   length=seq(min(length),max(length), by=1)
                                   
                       ))

#predict fish catch using new data frame
new.dat$catch <- predict(mod_inter,newdata=new.dat)


###plotting prediction + data with continuous example#
x11()
ggplot(new.dat,aes(x=length,y=log(catch),colour=river))+ 
  geom_line(aes(group=river))+ 
  geom_point(data=catdat, aes(x=length,y=log(catch),colour = river)) 
