
#load important packages##
library(ggplot2)
library(tidyverse)
library(tidyr)
library(dplyr)

#read my catch data
catdat=read.csv("catch.csv") 
head(catdat)
catdat <- catdat %>% 
  mutate(river = recode(river, "NEGRO" = "neg"))
catdat$river <- factor(catdat$river)

catdat$log=log(catdat$catch)
catdat$year <- as.numeric(format(as.Date(catdat$date, format="%d/%m/%Y"),"%Y"))
#Plotting my data with catch for each species between rivers 
ggplot(data=catdat, aes(x = spp, y = log, color=river))+
  geom_point(size=2)


#setting my own theme 
theme_set(theme_bw()+
            theme(axis.title=element_text(size=15),
                  axis.text=element_text(size=15),
                  panel.grid = element_blank(), 
                  axis.line=element_line(),
                  axis.text.x = element_text(angle = 45, hjust = 1),
                  legend.position="top",
                  legend.title = element_blank(),
                  legend.text = element_text(size=15),
                  legend.background = element_blank(),
                  legend.key=element_rect(fill="white",color="white")))

#creating a plot for each river 

#Purus River 
pur <- subset(catdat, river == "pur" & spp == "all") # points different boats 
    aggregate(log~spp,data=pur,  mean)
pur1=ggplot(data=pur,aes(x=as.factor(year),y=log), na.omit=T)+
  geom_point(size=2) #this adds points to graph
pur1
str(catdat)



g1=ggplot(data=catdat,aes(x=spp,y=catch))+
  facet_wrap(~river,ncol=1,nrow=3)+ #this is creating multiple "panels" for site
  geom_boxplot()+
  geom_point(aes(color=site),size=2)+
  ylab(expression(log[10]~spp~catch))+
  xlab("")+
  scale_colour_viridis(discrete = T)+
  theme_bw()+
  theme(axis.title=element_text(size=23),
        axis.text=element_text(size=15),
        panel.grid = element_blank(), 
        axis.line=element_line(),
        axis.text.x = element_text(angle = 90, hjust = 1,face="italic"),
        legend.position="top",
        legend.title = element_blank(),
        legend.text = element_text(size=20),
        legend.background = element_blank(),
        legend.key=element_rect(fill="white",color="white"))
g1


