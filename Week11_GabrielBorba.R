#ex11_model_comparison
rm(list=ls())

##load important packages##
library(ggplot2)
library(MASS)
library(reshape2)
library(tidyverse)
library(car)
library(AICcmodavg)

#using the catch data - read
catdat=read.csv("catch.csv") 
#round my catch values - inflated model, consider binomial or gamma with Tweedie Distribution
catdat$catch1 <- round(catdat$catch) #considering counting values - rounded catch

#Use likelihood ratio tests and one other model selection approach to test at 
#least 3 models of your data.
c1 = glm.nb(catch1~1,data = catdat) #null model 
c2 = glm.nb(catch1~length,data = catdat)
summary(c2)
c3 = glm.nb(catch1~length+river,data = catdat)
summary(c3)
c4 = glm.nb(catch1~length*river,data = catdat)
summary(c4)
#this test catch vs length + river
anova(c1,c2)
#this test catch vs light *time
anova(c1,c3)
#can look at all 3
anova(c1,c2,c3,c4,test = "LRT")

#Explain what the results are telling you for each approach.
#The likelihood ratio tests for model comparison shows the simple model including 
#only boat length is the one which has the lower difference in numbers of parameters 
#Based on the likelihood ratio test, length model is my best model that explained the relationship between catch and boat length from river sites. 



#AIC selection model
n1 = glm.nb(catch1~length,data = catdat)
n2 = glm.nb(catch1~river,data = catdat)
n3 = glm.nb(catch1~length+river,data = catdat)
n4 = glm.nb(catch1~length*river,data = catdat)
summary(n4)
n5 = glm.nb(catch1~1,data = catdat)
#for AICc
n=nrow(catdat)#or whatever the length of your df is

tabA = AIC(n1,n2,n3,n4,n5)
#it would be nice to have AICC for a dataset this small
tabA$k<-c(n1$rank,n2$rank,n3$rank,n4$rank,n5$rank)
tabA$aiccs<-tabA$AIC+((2*tabA$k*(tabA$k+1))/(n-tabA$k-1))
#now order from smallest to biggest
tabA=tabA[order(tabA$aiccs),]
#calculate delta AIC
tabA$dAIC = tabA$aiccs - min(tabA$aiccs)
#you use the next two lines to get weights
tabA$edel<-exp(-0.5*tabA$dAIC) 
tabA$wt<-tabA$edel/sum(tabA$edel)
tabA

#After ran each model structure, I checked model has the best weight based on dAIC. 
#The interactive model (n4) showed the high weight and lower dAIC from the rank 
#selection against the other model structures. 


######Extra - cross validation

##another example using caret##
library(caret)
library(psych)

data_ctrl <- trainControl(method = "cv", number = 10)
#We first set up the number of folds for cross-validation by defining the training control. 
#In this case, I chose 10 folds.

#run model with cross valdation
mod_1_caret <- train(catch1 ~ length + river,   # model to fit
                     data = catdat,                        
                     trControl = data_ctrl,              # folds
                     method = "glm.nb",                      # specifying regression model
                     na.action = na.pass)                # pass missing data to model - some models will handle this

mod_1_caret

summary(mod_2_caret$finalModel)

#We find that after using 5-fold cross-validation, 
#our model accounts for 42% of the variance (R-squared = 0.418) in ACT scores for these participants.

#We can also examine model predictions for each fold.
mod_2_caret$resample

#Furthermore, we can find the standard deviation around the 
#Rsquared value by examining the R-squared from each fold.
sd(mod_1_caret$resample$Rsquared)

##now model 2
#run model with cross validation
mod_2_caret <- train(catch1 ~  length * river,   # model to fit
                     data = catdat,                        
                     trControl = data_ctrl,              # folds
                     method = "glm.nb",                      # specifying regression model
                     na.action = na.pass)                # pass missing data to model - some models will handle this

mod_2_caret
#We find that after using 5-fold cross-validation, 
#mod_1 is the best model length + river
#sd(mod_2_caret$resample$Rsquared)
#0.0003856321
#sd(mod_1_caret$resample$Rsquared)
#0.0006616286