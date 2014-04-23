
%% Iteration 

%Finds optimal value function for parameters:
clear all
beta = .96;   % discount factor
r= .6135   %average rain
k=-.00346 %Slope of demand curve
g=1.1569+r  %Intercept of demand curve
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
n=2000
tic

%Returns cubic interpolation of optimal policy and value function and area
%function

[optimalchoice optimalvalue alpha policy policyint v X u1 ]=findpolicyeom(n,beta,r,k,g,c0,c1,A,rec,S,re,max_k,min_k,tol,maxit)


%Iterate it through time

j=200   %nubmer of years;
xstart=800 %initial level;
x=zeros(1,j) ;
x2=zeros(1,j) ;
x(1)=xstart;
x2(1)=xstart;
optimw= zeros(size(x));
myop= zeros(size(x));


for i=1:j;
   
    %if(x(i) <= .0000000001);
     %    fprintf('zero');
     %    break;
   % end;
    
    optimw(i)=optimalchoice(x(i));
    
    myop(i)= fminsearch(@(w) -u1(w,x2(i)),.2);
    

    x(i+1)= x(i) + + eom(rec,re,optimw(i),alpha(x(i)),S); %move stock forward
    x2(i+1)= x2(i) +  eom(rec,re,myop(i),alpha(x2(i)),S);
    
   
end

optimtot= alpha(x(1:end-1)).*optimw;
myoptot= alpha(x2(1:end-1)).*myop;
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


for i=1:j
    
    benefitopt(i)=  exp(-(1-beta)*i)*  u1(optimw(i),x(i));
    benefitmyop(i)=  exp(-(1-beta)*i)* u1(myop(i),x2(i));

end

benefitopttot=sum(benefitopt)
benefitmyoptot=sum(benefitmyop)
ratio=benefitopttot/benefitmyoptot

toc/60
save det_1

