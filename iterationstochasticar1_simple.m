
%% Iteration 

%Finds optimal value function for parameters:
clear all
load('/Users/nateme16/Documents/MATLAB/Groundwatater Todd 1/rainyearlyinches.mat')
load('/Users/nateme16/Documents/MATLAB/Groundwatater Todd 1/ar1start.mat')

beta = .96;   % discount factor
r=1   %average rain
k=-.89  %Slope of demand curve
g=1.48  %Intercept of demand curve
c0=.1664   %fixed pump cost
c1=-.0001664  %variable pump cost
A= 625    %Area of aquifer
rec=40    %Aquifer Recharge
S=.17   %Storitivity
re=.2   %percent returned irrigation water
max_k = 800; % max water level 
min_k = 400;  % min water level
tol = 1e-4; % convergence tolerance
maxit = 3000; % maximum number of loop iterations
n=100 %size of grid space of groundwater height

r=[.55 .65 .7]' %Expected rainfall states

j=2000    %nubmer of years in iteration;
tic

[prob]= [.5 .25 .25 ; .25 .5 .25; .25 .25 .5]'


%Returns cubic interpolation of optimal policy and value function and area
%function

[optimalchoice optimalvalue alpha policy policyint v X u1 ]=findpolicystochastic3ar1(n,beta,r,k,g,c0,c1,A,rec,S,re,max_k,min_k,tol,maxit,prob)

%Iterate it through time
%%NOT DONE YET FOR THIS CODE CORRECTLY!%%

xstart=800 %initial level;
x=zeros(1,j) ;
x2=zeros(1,j) ;
x(1)=xstart;
x2(1)=xstart;
optimw= zeros(size(x));
myop= zeros(size(x));

rn(1)=randsample(rain_yearlyinches,1,true)

for i=1:j
    rn(i+1)= 4.701501+.4102023.*rn(i) + randsample(err,1,true);
    rn(i+1)=roundtowardvec(rn(i+1),rain_yearlyinches,'round'); 
end


rn=rn./12 

mean(rn)

for i=1:j;
   
    %if(x(i) <= .0000000001);
     %    fprintf('zero');
     %    break;
   % end;
    
    
    optimw(i)=optimalchoice(rn(i),x(i));
    
    myop(i)= fminsearch(@(w) -u1(w,x2(i),rn(i)),.2);

    
    x(i+1)= x(i) + (( rec - (1-re)*optimw(i)*alpha(x(i))) / (A*S)); %move stock forward
    x2(i+1)= x2(i) + (( rec - (1-re)*myop(i)*alpha(x2(i))) / (A*S));
   
end

optimtot= alpha(x(1:end-1)).*optimw
myoptot= alpha(x2(1:end-1)).*myop

% plot results

subplot (2, 1, 1);
plot(x); 
title('Water Level Through Time');
ylabel('Water Table Elevation');
xlabel('Years');
hold on
subplot (2, 1, 1);
plot(x2); 
title('Water Level Through Time');
ylabel('Water Table Elevation');
xlabel('Years');
hold on

subplot (2, 1, 2);

plot(optimtot)
title('Water Extracted over Time');
ylabel('Acre Feet Total');
xlabel('Years');

hold on
subplot (2, 1, 2);
plot(myoptot)
title('Water Extracted over Time');
ylabel('Acre Feet Total');
xlabel('Years');

%% Calculate total discounted benefits
for i=1:j
    
    benefitopt(i)=  exp(-(1-beta)*i)*  u1(optimw(i),x(i),rn(i)).*A;
    benefitmyop(i)=  exp(-(1-beta)*i)* u1(myop(i),x2(i),rn(i)).*A;

end

benefitopttot=sum(benefitopt)
benefitoptmyop=sum(benefitmyop)

benefitopttot/benefitoptmyop


toc/60


