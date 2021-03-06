
%% Iteration 

%Finds optimal value function for parameters:
clear all
load('/Users/nateme16/Documents/MATLAB/Groundwatater Todd 1/rainyearlyinches.mat')
load('/Users/nateme16/Documents/MATLAB/Groundwatater Todd 1/ar1start.mat')

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
n=200
r=[.5 .6636 .7]' %Expected rainfall states

j=500    %nubmer of years in iteration;
tic

[prob]= [.5 .25 .25 ; .25 .5 .25; .25 .25 .5]'


%Returns cubic interpolation of optimal policy and value function and area
%function

[optimalchoice optimalvalue alpha policy policyint v X u1 ]=findpolicystochastic3ar1eom(n,beta,r,k,g,c0,c1,A,rec,S,re,max_k,min_k,tol,maxit,prob)

%Iterate it through time
%%NOT DONE YET FOR THIS CODE CORRECTLY!%%


for n=1:size(r,1)
    for i=1:size(X,2)

myop(i,n)= fminsearch(@(w) -u1(w,X(i),r(n)),.2);


    end
end


xstart=800 %initial level;
x=zeros(1,j) ;
x2=zeros(1,j) ;
x(1)=xstart;
x2(1)=xstart;
optimw= zeros(size(x));
myop= zeros(size(x));

rn(1)=randsample(r,1,true)

for i=1:j;% creates j length rainfall time series
    ind=randp(prob(:,find(r==rn(i)))',1,1);
    rn(i+1)=r(ind)   ;
end
 

mean(rn)

for i=1:j;
   
    %if(x(i) <= .0000000001);
     %    fprintf('zero');
     %    break;
   % end;
    
    
    optimw(i)=optimalchoice(rn(i),x(i));
    
    myop(i)= fminsearch(@(w) -u1(w,x2(i),rn(i)),.2);

    
    x(i+1)= x(i) + eom(rec,re,optimw(i),alpha(x(i)),S); %move stock forward
    x2(i+1)= x2(i)+ eom(rec,re,myop(i),alpha(x2(i)),S);
   
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
    
    benefitopt(i)=  exp(-(1-beta)*i)*  u1(optimw(i),x(i),rn(i));
    benefitmyop(i)=  exp(-(1-beta)*i)* u1(myop(i),x2(i),rn(i));

end

benefitopttot=sum(benefitopt)
benefitoptmyop=sum(benefitmyop)

ratio= benefitopttot/benefitoptmyop

save ar1_simple
toc/60


