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
#this test length vs length + river
anova(c1,c2)
#this test light vs light *time
anova(c1,c3)
#can look at all 3
anova(c1,c2,c3)
anova(c4,c3)

#Explain what the results are telling you for each approach.
##another example using caret##
library(caret)
library(psych)

#from: https://quantdev.ssri.psu.edu/tutorials/cross-validation-tutorial

data <- sat.act
head(data)

#models to compare

mod_1 = lm(ACT ~ gender + age + SATV + SATQ,   data = data)
summary(mod_1)

mod_2 = lm(ACT ~  gender + age ,   data = data)
summary(mod_2)

data_ctrl <- trainControl(method = "cv", number = 5)
#We first set up the number of folds for cross-validation by defining the training control. 
#In this case, we chose 5 folds, but the choice is ulimately up to you.

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
#run model with cross valdation
mod_2_caret <- train(catch1 ~  length * river,   # model to fit
                     data = catdat,                        
                     trControl = data_ctrl,              # folds
                     method = "glm.nb",                      # specifying regression model
                     na.action = na.pass)                # pass missing data to model - some models will handle this

mod_2_caret
#We find that after using 5-fold cross-validation, 
#our model also accounts for 1% of the variance (R-squared = 0.014) in ACT scores for these participants.

#mod_1 is the better model length + river
#sd(mod_2_caret$resample$Rsquared)
#0.0003856321
#sd(mod_1_caret$resample$Rsquared)
#0.0006616286
#the accuracy of cross-validation and the parameters from the whole sample should be reported.
#Include a synthesis statement on how the output of each approach is similar or different in your code. Remember to update your README and annotate your code.
