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

## WEEK 7##

CODE : Week7_GabrielBorba.R

DATA: catch.csv

First of all, I build a hypothesis that the catch values is significantly different between boat length. 

To check my hypothesis, I did a simple linear model where catch was my response variable and my boat length was my explanatory variable. 

I did a Shapiro test to check normally from my model but my dataset is too large, so I checked with a sample equals 5000 values. My p-value was <.005 so confirming that my data does not follow a normal distribution. 

After to check normally, I plotted the relationship between catch and length to visualize and confirm the results from the linear model that I did before.

Then, I plotted the relationship in ggplot using stat_smooth (method = "linear")

