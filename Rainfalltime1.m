%% This file is for the rain time series componant of our project
clear

n=1680     %number of months in sample  (Jan 1870 to Jan 1, 2011)
ncdisp('Kansas.nc')  %This is the metadata

rain_monthly= ncread('Kansas.nc','pr_wtr')  %reads in just the percipitation data

rain_monthly=squeeze(rain_monthly(1,1,1:n)) %taking only 1 of the 4 series

rain_yearly=zeros(n/12,1)

for j= 1: n/12 % Takes monthly to yearly totals
    
    i= 12*j
 
   
rain_yearly(j,1) = sum(rain_monthly(i-11:i));


end

rain_yearlyinches=rain_yearly.*0.0393701   %converts mm to inches
year=(1871:1:2010)'
plot(year,rain_yearly)


%%Estimate AR(4) Process on yearly data

y=rain_yearlyinches(5:end)
x1=rain_yearlyinches(4:end-1)
x2=rain_yearlyinches(3:end-2)
x3=rain_yearlyinches(2:end-3)
x4=rain_yearlyinches(1:end-4)


X=[ones(length(x1),1), x1,x2, x3, x4]

[Coef, CoefConfInt, e] = regress(y, X)% Does AR(4) estimate

[DWpVal, DWStat] = dwtest(e, X); % Perform a durbin watson test on the residuals
if DWpVal < 0.05; fprintf('WARNING: residuals from regression appear to be serially correlated. Estimated coefficients may not be consistent'); 
end

E=CoefConfInt(:,2)-CoefConfInt(:,1)
errorbar([1,2,3,4],Coef(2:end,:),E(2:end,:))


%%Make Graphs for rainfall over time


xmean=mean(rain_yearlyinches)

plot(year,(rain_yearlyinches-xmean))

%%Fit a distribution (maximum likelihood method)



    
