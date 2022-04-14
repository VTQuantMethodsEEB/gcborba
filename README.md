# gcborba

**BIOL 5504 – Quant Methods in Eco and Evo
Gabriel Borba**

  The dataset contains daily landing fisheries from the Amazon River Basin and the hydrological matrix. The data cover from 1993 to 2006 and have information for the main principal tributaries of the Amazon River. Fishing data includes variables such as date, common name species, boat, tributary river, effort, and yield. Hydrological data includes minimum, maximum, duration, and water levels (high and low waters). All hydrological information came from Brazil's National Water Agency (ANA) for the same period used for the fish catch. 

bid = boat id

pam = boat number

gear = gear type

success= 0 or 1 (catch or not)

boat = boat name

length = boat length 

## WEEK 1###

CODE : Week1_GabrielBorba.R
DATA: catch.csv
      hydro.csv

Here, I explored how to use R and did some basic calculations.

## WEEK 2##

CODE : Week2_GabrielBorba.R

DATA: catch.csv
      
Here, I explore my data by putting it in tidy format. I get for mistakes over my data and fixed it. By using mutate, I rename one of my rivers variable level. I ran summarise and mutate function to see output difference between them. 

## WEEK 3##

CODE : Week3_GabrielBorba.R

DATA: catch.csv
      
Here, I plot some different plots by using ggplot. First, I convert my zero values as NA values. Then, I create a new variable "year" in order to plot against my catch values. 
I created my own theme_set to visualize my plots. After I created my theme, I plotted catch data for each year and I picked river as a color.

To see differences on catch over the years, I plotted annual catch fish for each river.

## WEEK 5##

CODE : Week5_GabrielBorba.R

DATA: catch.csv

Here, I used my catch data to formulate two hypotheses:

H1= the catch mean is significantly higher in larger boat length than smaller boats.
H2= the catch mean is significantly different between rivers. 

First, I get if my variables have a normal distribution by plotting a histogram for each of them. Then, I check if the hypothesis H1 is true or false by running a non-parametric test because my variables have a non-normal distribution. 

I also ran a permutation test to check if my H1 is T or F by using the function onyway_test from coin package

For my H2, I used a loop for my permutation test. I scramble catch values from Amazon and Madeira river. In the for loop, I store difference in the means between the two rivers. 

After that, I got my observed mean difference and my mean difference from the permutation. By using these means I measured my p-value.   


## WEEK 6##
No assignment 


## WEEK 7##

CODE : Week7_GabrielBorba.R

DATA: catch.csv

First of all, I build a hypothesis that the catch values is significantly different between boat length. 

To check my hypothesis, I did a simple linear model where catch was my response variable and my boat length was my explanatory variable. 

I did a Shapiro test to check normally from my model but my dataset is too large, so I checked with a sample equals 5000 values. My p-value was <.005 so confirming that my data does not follow a normal distribution. 

After to check normally, I plotted the relationship between catch and length to visualize and confirm the results from the linear model that I did before.

Then, I plotted the relationship in ggplot using stat_smooth (method = "linear")

## WEEK 8##

#1. Make a linear model (with more than one variable) for one of your hypotheses. Articulate which hypothesis you are testing.
#Consider the length boat in addition to river sites


#H2 = the fish catch is significantly different for boat length and river sites.

#Output model results:

The Amazonas river is set as my intercept. There is a difference on fish catch from Amazonas and Negro river (p < 0.005) and catch also significantly varies over length boat (p < 0.005).

#2. Use an interactive model and an additive model. Explain what hypothesis each of these is testing, and what the R output is telling you about your data.

#H2 = the fish catch depends on length boat and river sites.

I ran an interactive model where my fish catch was set as response variable and boat length and river sites as a explanatory variables. 

mod_inter<-lm(catch~length*river, data=catdat)

Then, I ran allEffects function to check all average values from all my variable levels.

#Output model results:
The Amazon river boats is my intercept. The output shows that fish catch depends on boat length and river sites, where there is a significantly difference between fish catch from Amazon river comparing to other river sites and this difference is related to boat length. The average values for fish catch are different comparing length boat bins and between rivers. 

#3. Plot your model (e.g. using predict) and overlay the model on top of the underlying data. 

#Plot interpretation

Fish catch from Amazon river tens to be higher than others tributary rivers, the Negro river has the lowest catch and it would be related to physical-chemical characteristics from the water. The Negro River is categorized as a black waters river, which means poor nutrient and highly acidic waters. All the other rivers are white water rivers with nutrient and sediment rich, such characteristics contribute to a fish population growth and turn in high fish catch. 

## WEEK 10##
CODE : Week11_GabrielBorba.R

DATA: catch.csv

I did a GLM model with negative binomial family based on the residual distribution that I got from last week.

H = the fish catch is significantly different for boat length and river sites.

My catch variable is fish catch/kg, so I rounded my catch values to get integer values. 

#Explain what the R output is telling you about your data, in relation to your hypothesis.


#Explanation =
The fish catch seems to be significant related to the boat length and the river site which was caugth.As my river variable is categorical, my Amazonas river sites where set as intercept. The fish catch from Amazonas river seen to depend on the boat length, and this relationship is significant different when comparing with the others rivers.   

Then, I plot my observed data and predict data overlap to see if they fits appropriately. 
I used predict function to see if my observed data fits well with predict values.


## WEEK 11##

CODE : Week11_GabrielBorba.R

DATA: catch.csv

I did a GLM model with negative binomial family based on the residual distribution that I got from last week.  

#Likelihood ratio test 

For likelihood ratio tests, I used 3 models from my data: 

modelnull= a null model (catch~1); 
model= a simple model (catch~length);
model1= an additive model (catch~length+river) 
model2= an interactive model (catch~length*river). 

The likelihood ratio tests for model comparison shows the simple model is the one which has a lower difference in numbers of parameters. Based on the likelihood ratio test, length model is my best model that explained the relationship between catch and boat length from river sites. 


#Model selection 

#AIC model selection

n1 = catch~length
n2 = catch~river
n3 = catch~length+river
n4 = catch~length*river
n5 = catch~1

After ran each model structure, I checked model has the best weight based on dAIC. The interactive model (n4) showed the high weight and lower dAIC from the rank selection against the other model structures. 

#cross-validation(extra)

For a model selection approach, I choose to use cross-validation function from the package caret. First, I set up the number of folds for cross-validation by defining the training control. I chose 10 folds, which means divide data into ten parts, and using model to predict the remaining 10%. 

I used my two models, one additive (model 1) and another interactive (model2).
My model 1 accounts for 0.07% of the variance (R-squared = 0.0007) in catch scores.

