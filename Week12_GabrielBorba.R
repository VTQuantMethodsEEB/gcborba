rm(list=ls())

##load important packages##
library(lme4)
library(glmmTMB)
#using the catch data - read
catdat=read.csv("catch.csv") 

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



