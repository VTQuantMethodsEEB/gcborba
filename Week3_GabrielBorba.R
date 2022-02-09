rm(list=ls()) # clears workspace
#load important packages##
library(ggplot2)
library(tidyverse)
library(tidyr)
library(dplyr)

#read my catch data
catdat=read.csv("catch.csv") 
catdat[catdat ==0] <- NA
catdat <- catdat %>% 
  mutate(river = recode(river, "NEGRO" = "neg"), na.rm=T)

  catdat$river <-as.factor(catdat$river)
  catdat$log <- log(catdat$catch)
  catdat$year <- as.factor(format(as.Date(catdat$date, format="%m/%d/%Y"),"%Y"))
#Plotting my data with catch for each species between rivers 
ggplot(data=catdat, aes(x = year, y = log, color=river))+
  geom_point(size=2)


#setting my own theme 
theme_set(theme_bw()+
            theme(axis.title=element_text(size=15),
                  axis.title.x = element_blank(),
                  axis.text=element_text(size=15),
                  panel.grid = element_blank(), 
                  axis.line=element_line(),
                  axis.text.x = element_text(angle = 45, hjust = 1),
                  legend.position="top",
                  legend.title = element_blank(),
                  legend.text = element_text(size=15),
                  legend.background = element_blank(),
                  legend.key=element_rect(fill="white",color="white")))
#ggplot combining boxplot and jitter for my log(catch) and spp
g1=ggplot(data=catdat,aes(x=spp,y=log)) + labs(x="species",y="log(catch)") +
  geom_boxplot()+
  geom_jitter()

#creating a plot for each river 

#Purus River 
pur <- subset(catdat, river == "pur" & spp == "all", na.rm=T) # points different boats 
    
pur1=ggplot(data=pur,aes(x=year,y=log),color=river, na.rm=T, group=13)+
  geom_line()+ylab("log(catch)")  #this adds points to graph
pur1 + scale_y_continuous(limits=c(2.5, 12))
#Amazonas River 
amz <- subset(catdat, river == "amz" & spp == "all", na.rm=T) # points different boats 

amz1=ggplot(data=amz,aes(x=as.factor(year),y=log), na.rm=T)+
  geom_point(size=2)+ylab("log(catch)")  #this adds points to graph
#Negro River 
neg <- subset(catdat, river == "neg" & spp == "all", na.rm=T) # points different boats 

neg1=ggplot(data=neg,aes(x=as.factor(year),y=log), na.rm=T)+
  geom_point(size=2)+ylab("log(catch)")  #this adds points to graph

#Madeira River 
mad <- subset(catdat, river == "mad" & spp == "all", na.rm=T) # points different boats 

mad1=ggplot(data=mad,aes(x=as.factor(year),y=log), na.rm=T)+
  geom_point(size=2)+ylab("log(catch)")  #this adds points to graph



#multiple panels with catch for each river over years 
g1=ggplot(data=catdat,aes(x=year,y=log))+
  facet_wrap(~river,ncol=2,nrow=2)+ #this is creating multiple "panels" for site
  geom_boxplot()+
  geom_point(aes(color=spp),size=2)+
  ylab("log (catch)")+
  xlab("")+
  theme_bw()+
  theme(axis.title=element_text(size=23),
        axis.text=element_text(size=15),
        panel.grid = element_blank(), 
        axis.line=element_line(),
        axis.text.x = element_text(angle = 90, hjust = 1,face="italic"),
        legend.position="top",
        legend.title =element_blank(),
        legend.text = element_text(size=20),
        legend.background = element_blank(),
        legend.key=element_rect(fill="white",color="white"))
g1


