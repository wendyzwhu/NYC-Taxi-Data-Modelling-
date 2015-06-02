
R-Bootstrap:
##Computing on server Gumbel
install.packages("boot")
library("boot")
library("read.table")

###upload the five sample files to the server take one of file as an example here
setwd("/home/zhewenhu")
sample = fread("mergesample1.csv",header = TRUE,sep = ",")

beta <- function(formula,data,indices){
  d<-data[indices,]
  fit<-lm(formula,data=d)
  return(fit$coef)
}

samplemodel <- boot(data = sample, statistic = beta, R = 10, formula = decile ~ triptime)
samplemodel2 <- boot(data = sample, statistic = beta, R = 10, formula = decile ~ triptime + surcharge)
boot.ci(samplemodel)
print(samplemodel)
print(samplemodel2)

timemodel = system.time(boot(data = sample, statistic = beta, R = 10, formula = decile ~ triptime))
timemodel2 = system.time(boot(data = sample, statistic = beta, R = 10, formula = decile ~ triptime + surcharge))


Method Two:
##Multiple files for the first question
con11 = pipe("cut -f11 -d, *trip_fare*", open = 'r')
con10 = pipe("cut -f10 -d, *trip_fare*", open = 'r')
total = readLines(con11)
tolls = readLines(con10)
total.numeric = as.numeric(as.character(total))
tolls.numeric = as.numeric(as.character(tolls))
decile = total.numeric - tolls.numeric
decile.new = decile[!is.na(decile)] ##get rid of the header 

##triptime
contime = pipe("cut -f9 -d, *trip_data*", open ='r')
triptime = readLines(contime)
triptime.new = as.numeric(as.character(triptime))
triptime.new.1 = triptime[!is.na(triptime)]

##surcharge
concharge = pipe("cut -f7 -d, *trip_fare*", open = 'r')
surcharge = readLines(concharge)
surcharge = as.numeric(as.character(surcharge))
surcharge.new = surcharge[!is.na(surcharge)]

##cbind into a data table 
surcharge.new.1 = surcharge[-(1:9)]
triptime.new.1 = triptime.new[-(1:9)]
modeldata = cbind(triptime.new.1,surcharge.new.1,trip)

##Question one quantile
deciles = quantile(modeldata$decile.new.1,c(.1,.2,.3,.4,.5,.6,.7,.8,.9))

##big funtion to be measured for the system time
decilecalculation = function()(
  con11 = pipe("cut -f11 -d, *trip_fare*", open = 'r')
  con10 = pipe("cut -f10 -d, *trip_fare*", open = 'r')
  total = readLines(con11)
  tolls = readLines(con10)
  total.numeric = as.numeric(as.character(total))
  tolls.numeric = as.numeric(as.character(tolls))
  decile = total.numeric - tolls.numeric
  decile.new = decile[!is.na(decile)])
  
  system.time(decileculation())
##system time for data table 
datatablecal = function()(
  con11 = pipe("cut -f11 -d, *trip_fare*", open = 'r')
  con10 = pipe("cut -f10 -d, *trip_fare*", open = 'r')
  total = readLines(con11)
  tolls = readLines(con10)
  total.numeric = as.numeric(as.character(total))
  tolls.numeric = as.numeric(as.character(tolls))
  decile = total.numeric - tolls.numeric
  decile.new = decile[!is.na(decile)]
  concharge = pipe("cut -f7 -d, *trip_fare*", open = 'r')
  surcharge = readLines(concharge)
  surcharge = as.numeric(as.character(surcharge))
  surcharge.new = surcharge[!is.na(surcharge)]
  surcharge.new.1 = surcharge[-(1:9)]
  decile.new.1 = triptime.new[-(1:9)]
  modeldata = cbind(decile.new.1,surcharge.new.1,triptime.new))
system.time(datatablecal())

##Step two Using biglm()
library(biglm)
model1 = biglm(decile.new ~ triptime.new, data = modeldata)
model2 = biglm(decile.new ~ triptime.new + surcharge.new, data = modeldata)
system.time(biglm(decile.new ~ triptime.new, data = modeldata))
system.time(biglm(decile.new ~ triptime.new, data = modeldata))

##Final Step Visualization 
##Computing time 
shelltime = c(2675.55,2600.47,2380.55,2887.63,2554.34)
calculationbigquery = c(16.6,15.3,13.3,17.2,18.5)
mergebigquery = c(6391.5,6290.4,6190.4,5391.5,6190.8)
samplingbigquery = c(364.9,347.5,363.3,398.7,384.4)
allbigquery = calculationbigquery + mergebigquery + samplingbigquery
g_range = range(0,allbigquery)
plot(mergebigquery,type = "p", col = "blue", ylim = g_range,xlab="Trial Times",ylab = "Elapsed time (s)", main = "Comparison of System Time")
lines(allbigquery,type="l",col = "green")
lines(calculationbigquery, type = "o", col = "red")
lines(samplingbigquery, type = "b", col = "forestgreen")
lines(shelltime,type = 'c', col = "yellow")
legend("center", c("mergebigquery","allbigquery","calculationbigquery","samplingbigquery","shelltime"), cex=0.8, col= c("blue","green","red","forestgreen","yellow"), 
       lty=1:5, lwd=2, bty="n")

##plot programming time 
timemodel2.2 = c(512.662,6.872,519.825)
timemodel2.1 = c(304.823,5.765,310.759)
timemodel1.1 = c(1067.287,87.281,1355.201)
timemodel1.2 = c(934.670,38.597,940.689)
timeall = cbind(timemodel1.1,timemodel1.2,timemodel2.1,timemodel2.2)
timeall.new = as.matrix(timeall,dimnames = list(c("user","system","elapse"),c("model1.1","model1.2","model2.1","model2.2")))
barplot(timeall,beside = TRUE,ylab = "System Time(sec)", main = "Comparison of Time for Two Approaches",col = rainbow(3))
legend("topright", c("user","system","elapsed"), cex=0.6, 
       bty="n", fill=rainbow(3))




