rm(list=ls())
#loading package used
library(coin)


#using the catch data - read
catdat=read.csv("catch.csv") 
hyd=read.csv("hydro.csv")


#Formulate two different hypotheses about your data, one that can be tested 
#using a permutation test and one that can be tested using a “classical” test.

#H1= the mean of catch success are significantly different for boat length
#H2= the mean of catch success are significantly different for catch effort

#I get if my variables are normal by visualizing a histogram of frequency 
hist(catdat$length)
hist(catdat$success)

#Cause my data set is larger than 50000 so R does not allow me to run a Shapiro Test
shapiro.test(catdat$length)#normal data distributed 
shapiro.test(catdat$success)

#it turns that they are not normal, so I will run a non-parametric test
t.h1 <- t.test(length~success,data=catdat,var.equal=TRUE)

stripchart(length~factor(success),pch=19, at=c(1.3,1.7), v=T,data=catdat)
kruskal_test(length~factor(success),data=catdat)




#### permutation tests######
#Permutation test using my H2 = the mean of catch success are significantly different for catch effort
oneway_test(effort~factor(success),data=catdat)

oneway_test(effort~factor(success),data=catdat,distribution="exact")

oneway_test(effort~factor(success),data=catdat,distribution=approximate(nresample=9999))


#the mean of catch are significantly different for river 
ama=subset(catdat$catch,catdat$river=="amz")
mad=subset(catdat$catch,catdat$river=="mad")
#4. Try to use a loop for your permutation test (e.g. a brute force method).  
#Use any classical test you learned about to test your other hypothesis.
set.seed(100)
#set.seed will set R's random number generator to start at the same place
#this ensures that when you, and I, and anyone else, does the test, we will all get the same results

result <- NA 


for (i in 1:100) {
  catchboot <- sample(c(ama,mad)) ## scramble
  ## 
  amaboot <- catchboot[1:length(ama)]  #this says assign the first six colonies to forest
  madboot <- catchboot[(length(mad)+1):length(catchboot)] #assign the rest of the colonies to field
  
  ## compute & store difference in means
result[i] <- mean(amaboot)-mean(madboot) #calculate the difference in the field means and the forest means
  #[i] says "where i", and i is a counter, after running this loop, i should be 1000
}

#what is our observed mean difference?
obs <- mean(ama)-mean(mad)
obs
result[result>=obs]
length(result[result>=obs])
235/100
mean(result>=obs)    

#we could double the p-value
2*mean(result>=obs)          ## doubling

#or we could count the area in both tails
mean(abs(result)>=abs(obs))

#testing 
t.test(result)
