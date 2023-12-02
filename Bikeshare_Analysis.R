#Manoj Naidu Arasada

#loading the data
rm(list=ls())
library(readxl)
d<- read_excel("Bikeshare.xlsx", sheet="Data")
colnames(d)=tolower(make.names(colnames(d)))
attach(d)
str(d)


#featuring engineering
#finding for null values
colSums(is.na(d))

#converting date into date format
d$date = as.Date(d$date)

#extracting year from date and making it as factor
d$year = factor(format(d$date, "%Y"))

#extracting monht from date and making it as factor
d$month = factor(format(d$date, "%m"))

#extracting day from date and making it as factor
d$day = factor(format(d$date, "%d"))

#naming the months and days accordingly
d$month =factor(month.name[d$month]) 

d$day =  factor(weekdays(d$date))

d$season=factor(d$season)

d$season=factor(d$season)

d$holiday=factor(d$holiday)

d$workday=factor(d$workday)

d$weather=factor(d$weather)

d$weekend = factor(ifelse(d$day=="Saturday" | d$day =="Sunday", 1,0))


#distribution of dependent variables
#data viz
hist(d$count)
hist(log(d$count))
hist(d$registered)
hist(log(d$registered))
hist(d$casual)
hist(log(d$casual))

agg <- aggregate(count ~ day, data = d, sum)

boxplot((count)~year, data = d)
boxplot((count)~month, data = d)
boxplot((count)~day, data = d)

library(PerformanceAnalytics)
temp <- d[, c(5:11)]
chart.Correlation(temp) 

str(d)
levels()

#models

#poisson models
m1 = glm(count ~ holiday+weekend+weather+fltemp+humidity+windspeed+hour+year+month+day,family = poisson(link = log), data = d)

m2 = glm(registered ~ holiday+weekend+weather+fltemp+humidity+windspeed+hour+year+month+day,family = poisson(link = log), data = d)

m3 = glm(casual ~ holiday+weekend+weather+fltemp+humidity+windspeed+hour+year+month+day,family = poisson(link = log), data = d)

library(stargazer)
stargazer(m1,m2,m3, type="text", single.row=TRUE)

#overdispersion test

library(AER)
dispersiontest(m1)
mean(d$count)
dispersiontest(m2)
mean(d$registered)

dispersiontest(m3)
mean(d$casual)        #failed



#lets us create a new variable called holiday and a weekday

d$holiweek = factor(ifelse(d$holiday==1 & d$weekend == 0,1,0))
d$hour=factor(d$hour)


#negative binomial models


library(MASS)
m4 = glm.nb(count ~ holiweek +weekend+weather+fltemp+humidity+windspeed+hour+year+month+day, data = d)


m5 = glm.nb(registered ~ holiweek+weekend+weather+fltemp+humidity+windspeed+hour+year+month+day, data = d)


m6 = glm.nb(casual ~ holiweek+weekend+weather+fltemp+humidity+windspeed+hour+year+month+day, data = d)

library(lmtest)
dwtest(m4)
dwtest(m5)
dwtest(m6)

stargazer(m4,m5,m6, type = "text", single.row = TRUE) 


boxplot(log(count)~month, data = d)

