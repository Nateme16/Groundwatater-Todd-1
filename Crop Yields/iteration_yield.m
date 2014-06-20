
%% Iteration Simple Yield

%Finds optimal value function for parameters:
clear all
beta = .96;   % discount factor
r= 1.6102    %average rain

c0=104   %fixed pump cost
c1=-(104/943) %variable pump cost

pc=4.47
ps=4.25

A= 3110000 %Area of aquifer
farm=.12   %area of aquifer farmed 
rec=40*(A/625)    %Aquifer Recharge
S=.17   %Storitivity
re=.2   %percent returned irrigation water
max_k = 916; % max water level 
min_k = 741;  % min water level
tol = 1e-10; % convergence tolerance
maxit = 4000; % maximum number of loop iterations for value function convergence
n=100 %Grid space over stock

%% Solve the optimal value and policy function
tic

[policy policyopt v X R wp] = findpolicy_yield(n,beta,r,c0,c1,ps,pc,A,rec,S,re,max_k,min_k,tol,maxit,farm);

for i=1:size(X,2);
    x=X(i);
 policy_myop(i)=fminsearch(@(w) -pi_total_yield(w,r,c0,c1,ps,pc,irrig(A,max_k,min_k,x,farm),A,x,farm),.1);
    
end


%% iteration


%Iterate it through time

j=500   %nubmer of years;
xstart=916 %initial level;
x=zeros(1,j) ;
x2=zeros(1,j) ;
x(1)=xstart;
x2(1)=xstart;
optimw= zeros(size(x));
myop= zeros(size(x));


for i=1:j;
    
    optimw(i)=policyopt(x(i));
    
    myop(i)=  fminsearch(@(w) - pi_total_yield(w,r,c0,c1,ps,pc,irrig(A,max_k,min_k,x2(i),farm),A,x2(i),farm),.1); 

    x(i+1)= x(i)  + eom2(rec,re,optimw(i),irrig(A,max_k,min_k,x(i),farm),S,farm); %move stock forward
    x2(i+1)= x2(i) +  eom2(rec,re,myop(i),irrig(A,max_k,min_k,x2(i),farm),S,farm);
   
end

%% Get benefits
for i=1:j
    
    benefitopt(i)=  exp(-(1-beta)*i)*  pi_total_yield(optimw(i),r,c0,c1,ps,pc,irrig(A,max_k,min_k,x(i),farm),A,x(i),farm);
    benefitmyop(i)=  exp(-(1-beta)*i)* pi_total_yield(myop(i),r,c0,c1,ps,pc,irrig(A,max_k,min_k,x2(i),farm),A,x2(i),farm);
  
end

benefitopttot=sum(benefitopt)
benefitmyoptot=sum(benefitmyop)
ratio=benefitopttot/benefitmyoptot

%% plots to make

plot(x)
hold on
plot(x2)


%plot(X,irrig(A,max_k,min_k,X).*policy);
%hold on
%plot(X,irrig(A,max_k,min_k,X).*policy_myop);

%plot(X,policy)
%hold on
%plot(X,policy_myop)

ElapsedTime= toc/60

h = datestr(clock,0);
save(['det_yield',h(1:11),'-',h(13:14),'-',h(16:17),'-',h(19:20)]);
