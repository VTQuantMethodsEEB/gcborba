rm(list=ls())

##load important packages##
library(lme4)

#using the catch data - read
catdat=read.csv("catch.csv") 

#round my catch values 
catdat$catch1 <- round(catdat$catch)
catdat<-scale(cbind(catdat$effort,catdat$length))
#H: fish catch depends on interaction between boat length and 
#effort, taking account and controlling the distribution of my boat id.

## run mixed model
m.nb <- glmer.nb(catdat$catch1 ~ length*effort+(1|catdat$boat), data=cat.scaled)
summary(m.nb)
cat.scaled <- as.data.frame(scale(catdat[,c(5,10)]))
catdat1<- scale(catdat)
catdat$effort1 <- scale(effort)
#look at mixed model
summary(m.nb)



