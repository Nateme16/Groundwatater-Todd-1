
%% Iteration Simple

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
maxit = 3000; % maximum number of loop iterations for value function convergence
n=100 %Grid space over stock

%% Solve the optimal value and policy function

findpolicy_simple2(n,beta,r,k,g,c0,c1,A,rec,S,re,max_k,min_k,tol,maxit)


