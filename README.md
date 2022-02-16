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

DATA: catch_data.csv
      
Here, I plot some different plots by using ggplot. First, I plotted catch data for each spp between different rivers. I plotted a ggplot for each one of my river sites 