% This file is for the rain time series componant of our project
clear

n=1680
ncdisp('Kansas.nc')

rain_monthly= ncread('Kansas.nc','pr_wtr')

rain_monthly=squeeze(rain_monthly(1,1,1:n))

rain_yearly=zeros(n/12,1)

for j= 1: n/12
    
    i= 12*j
 
   
rain_yearly(j,1) = sum(rain_monthly(i-11:i));


end


year=(1871:1:2010)'
plot(year,rain_yearly)


