rm(list=ls()) 
library(MASS)
library(ggplot2)
#using the catch data - read
catdat=read.csv("catch.csv") 
str(catdat)

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
#make a new dataframe
new.dat <- with(expand.grid(river=levels(catdat$river), 
                            length=seq(min(catdat$length),max(catdat$length), by=1)))

#predict fish catch using new data frame
new.dat$catch <- predict(mod.glm,newdata=new.dat)
#What does this tell us?
dat.new=expand.grid(date=seq(from = min(catdat$catch1),to = max(catdat$catch1),
                             length.out = 100),
                    river = unique(catdat$river))
#GIVE HER AN ANSWER

#much more sensible output
dat.glm$ypred  = predict(mod.glm,type="response",newdata = dat.new)
catdat$ypred1 = predict(mod.glm,type="response")
head(dat.new)

head(bat)

plot1=ggplot(data=catdat,aes(x=length,y=catch1,color=river))+
  geom_point(size=2,shape =1)
  #+
#geom_line(aes(x=date,y=yhat2,col = species))
plot1
