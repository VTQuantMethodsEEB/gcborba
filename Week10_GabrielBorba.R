rm(list=ls()) 
library(MASS)
library(ggplot2)
#using the catch data - read
catdat=read.csv("catch.csv") 
catdat=na.omit(catdat)

#Make a generalized linear model (preferably with more than one variable) for one of your hypotheses. Articulate which hypothesis you are testing.

#Distribution would be Gamma or negative binomial
#H = the fish catch is significantly different for boat length and river sites.

#round my catch values - inflated model
catdat$catch1 <- round(catdat$catch) #considering counting values - rounded catch

mod.glm = glm.nb(catch1~length+river, data=catdat,control = glm.control(maxit = 50))
summary(mod.glm)

#Explain what the R output is telling you about your data, in relation to your hypothesis.
#(Hint: you can use emmeans, effects, relevel, or predict to help you.)

#Explanation = 
#Plot your model (e.g. using predict) and overlay the model on top of the underlying data. Remember that you will need to use “type=response”.

new.dat <- with(catdat,
                expand.grid(river=levels(river), 
                            length=seq(min(length),max(length), by=1)
                            
                ))
#predict fish catch using new data frame
new.dat$catch <- predict(mod.glm,newdata=new.dat)
#What does this tell us?
dat.new=expand.grid(length=seq(from = min(catdat$length),to = max(catdat$length),
                             length.out = 100),river = unique(catdat$river))

#much more sensible output
dat.new$ypred  = predict(mod.glm,type="response",newdata = dat.new)
catdat$ypred1 = predict(mod.glm,type="response")



plot1=ggplot(data=catdat,aes(x=length,y=catch1,color=river))+
  geom_point(size=2,shape =1)+
  geom_line(data=dat.new, aes(x=length,y=ypred,col = river)) +
  geom_line(data=catdat,aes(x=length,y=ypred1,col = river))
plot1
