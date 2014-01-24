
%% Iteration 

%Finds optimal value function for parameters:
clear all
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
n=10000
tic
%Returns cubic interpolation of optimal policy and value function and area
%function
[optimalchoice optimalvalue alpha policy policyint v X R]=findpolicy(n,beta,r,k,g,c0,c1,A,rec,S,re,max_k,min_k,tol,maxit)


%Iterate it through time

j=2000    %nubmer of years
xstart=800 %initial level
x=zeros(1,j) 
x(1)=xstart
w= zeros(size(x))


for i=1:j
   
    %if(x(i) <= .0000000001);
     %    fprintf('zero');
     %    break;
   % end;
    
    w(i)=optimalchoice(x(i));
    
    x(i+1)= x(i) + ( r - (1-re)*w(i)*alpha(x(i))) / (A*S); %move stock forward
    
end

% plot results

subplot (2, 1, 1);
plot(x); 
title('Water Level Through Time');
xlabel('Water Table Elevation');
ylabel('Years');

subplot (2, 1, 2);
plot(w)

toc/60


