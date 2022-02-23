rm(list=ls())
#loading package used
library(coin)
library(ggplot2)
library(tidyverse)
library(tidyr)
library(dplyr)
#using the catch data - read
catdat=read.csv("catch.csv") 
hyd=read.csv("hydro.csv")


#Formulate two different hypotheses about your data, one that can be tested 
#using a permutation test and one that can be tested using a “classical” test.

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

View(fish)

#My data set is larger than 50000 so R does not allow me to run a Shapiro Test
shapiro.test(catdat$length)#normal data distributed 
shapiro.test(catdat$success)

#So, I check if my variables are normal by visualizing a histogram of frequency 

hist(small$catch)
hist(small$length)



#it turns that they are not normal, so I will run a non-parametric test

wilcox.test(catch~factor(length),data=fish)

# p<0.05, catch values from small and large boat length are nonidentical populations, they have different data distribution

#Plot
theme_set(theme_bw()+ #set my theme as a default for my plot 
            theme(axis.title=element_text(size=23),
                  axis.text=element_text(size=15),
                  panel.grid = element_blank(), 
                  axis.line=element_line(),
                  axis.text.x = element_text("")))
stripchart(catch~factor(length),data=fish,pch=19, at=c(1.3,1.7), v=T)
points(mean(fish$catch), col="red")
x11()
g1=ggplot(data=fish,aes(x=factor(length),y=log(catch)))+
    geom_boxplot()+
  geom_point() 
g1+xlab("Boat length")


#### permutation tests######
#Permutation test using my H1 = the mean of catch success is significantly higher in larger boat length than smaller boats. 
oneway_test(catch~factor(length),data=fish)

oneway_test(effort~factor(success),data=catdat,distribution=approximate(nresample=9999))


#Try to use a loop for your permutation test (e.g. a brute force method).  
#Use any classical test you learned about to test your other hypothesis.

set.seed(101)
#set.seed will set R's random number generator to start at the same place
#this ensures that when you, and I, and anyone else, does the test, we will all get the same results

result <- NA 

#the mean of catch are significantly different for rivers 
ama=subset(catdat$catch,catdat$river=="amz", na.omit=T)
mad=subset(catdat$catch,catdat$river=="mad")

for (i in 1:1000) {
  catchboot <- sample(c(ama,mad)) ## scramble
  ## '
  amaboot <- catchboot[1:length(ama)]  #this says assign the first values 
  madboot <- catchboot[(length(ama)+1):length(catchboot)] #assign the rest of the colonies to field
  
  ## compute & store difference in means
result[i] <- mean(madboot)-mean(amaboot) #calculate the difference in river means
  #[i] says "where i", and i is a counter, after running this loop, i should be 1000
}

#what is my observed mean difference?
obs <- mean(mad)-mean(ama)
obs

mean(result>=obs)    

#my observed mean difference is very far from my mean difference from permutation test 
hist(result,col="gray",las=1,main="", xlim= c(-100, 100))
abline(v=obs,col="red")

#t test for my mean difference values from permutation test 
t.test(result)

#p>0.05, indicates that my mean differences are not significant 

#no parametric for my observed mean difference between rivers 
wilcox.test(obs)
#p>0.05, indicates that my mean differences are not significant 
