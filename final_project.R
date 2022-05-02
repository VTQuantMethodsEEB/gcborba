rm(list=ls())

##load important packages##
library(tidyverse)
library(tidyr)
library(dplyr)
library(glmmTMB)
library(ggplot2)
#using the catch data - read
catdat=read.csv("catch.csv") 

catdat <- catdat %>% 
  mutate(river = recode(river, "NEGRO" = "neg"))#rename river 
catdat$river <- factor(catdat$river)

#round my catch values and scale predictors
catdat$catch1 <- round(catdat$catch)
catdat$effort1<-scale(catdat$effort)
catdat$length1<-scale(catdat$length)
#including new columns 
#H: fish catch depends on interaction between boat length and 
#effort among river sites, taking account and controlling the distribution of my boat id.

#try glmm.tb
## run mixed model
m.nb1 <- glmmTMB(catch1 ~ length1*effort1 + river + (1|boat), data=catdat, family=nbinom2)

#look at mixed model
summary(m.nb1)

plot1=ggplot(data=catdat,aes(x=length,y=catch1,color=river))+
  geom_point(size=3)+ylab("Catch (kg)")+xlab("Boat length (m)")

plot1+theme_test()+scale_color_discrete(name = "River")
