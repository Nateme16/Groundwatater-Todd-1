
%% Iteration 

%Finds optimal value function for parameters:
clear all
load('/Users/nateme16/Documents/MATLAB/Groundwatater Todd 1/rainyearlyinches.mat')

beta = .96;   % discount factor
ar= 7.9635/12   %average rain
k=-.00346 %Slope of demand curve
g=1.1569+ar  %Intercept of demand curve
c0=104   %fixed pump cost
c1=-(104/1000) %variable pump cost
A= 625    %Area of aquifer
rec=40    %Aquifer Recharge
S=.17   %Storitivity
re=.2   %percent returned irrigation water
max_k = 800; % max water level 
min_k = 400;  % min water level
tol = 1e-4; % convergence tolerance
maxit = 3000; % maximum number of loop iterations
n=300
r=[.5 .6636 .7]' %Expected rainfall states
P=zeros(size(r))
P(:,:)=1/size(r,1) %Expected probability of rainfall sates

j=200    %nubmer of years in iteration;
tic



%Returns cubic interpolation of optimal policy and value function and area
%function

[optimalchoice optimalvalue alpha policy policyint v X u1 ]=findpolicystochasticeom(n,beta,r,k,g,c0,c1,A,rec,S,re,max_k,min_k,tol,maxit,P)

%Iterate it through time

xstart=800 %initial level;
x=zeros(1,j) ;
x2=zeros(1,j) ;
x(1)=xstart;
x2(1)=xstart;
optimw= zeros(size(x));
myop= zeros(size(x));


rn=randsample(r,j,true) %random draws for rainfall realizations
mean(rn)

for i=1:j;
   
    
    optimw(i)=optimalchoice(rn(i),x(i));
    
    myop(i)= fminsearch(@(w) -u1(w,x2(i),rn(i)),.2);

    
    x(i+1)= x(i) + eom(rec,re,optimw(i),alpha(x(i)),S) ; %move stock forward
    x2(i+1)= x2(i) + eom(rec,re,myop(i),alpha(x2(i)),S)  ;
   
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
    
    benefitopt(i)=  exp(-(1-beta)*i)* u1(optimw(i),x(i),rn(i));
    benefitmyop(i)=  exp(-(1-beta)*i)* u1(myop(i),x2(i),rn(i));

end

benefitopttot=sum(benefitopt)
benefitoptmyop=sum(benefitmyop)

ratio= benefitopttot/benefitoptmyop

save stoch_simple

%load('/Users/nateme16/Documents/MATLAB/Groundwatater Todd 1/optimalvaluedet.mat')

%% Buffer value through time
%buffvalopt=(optimalvaluedet(x)-optimalvaluedet(400)).*A
%buffvaloptstoch=(optimalvalue(rn,x(1:end-1))-optimalvalue(rn,401)).*A

%buffdiffopt= buffvaloptstoch- buffvalopt(1:end-1)

%buffvalmyop=(optimalvaluedet(x2)-optimalvaluedet(400))*A
%buffvalmyopstoch=(optimalvalue(rn,x2(1:end-1))-optimalvalue(rn,401))*A

%buffdiffmyop= buffvalmyopstoch- buffvalmyop(1:end-1)

toc/60


