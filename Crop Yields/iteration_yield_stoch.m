
%% Iteration Stochastic Yield

%Finds optimal value function for parameters:
clear all
beta = .96;   % discount factor
r= 1.5833   %average rain

c0=104   %fixed pump cost
c1=-(104/1000) %variable pump cost

pc=4.4
ps=4.4

A= 625   %Area of aquifer
rec=40 %*76250    %Aquifer Recharge
S=.17   %Storitivity
re=.2   %percent returned irrigation water
max_k = 800; % max water level 
min_k = 400;  % min water level
tol = 1e-10; % convergence tolerance
maxit = 3000; % maximum number of loop iterations for value function convergence
n=200 %Grid space over stock

r=[1.25 r 2]
P=[0.30952381 0.378378378 0.3121]

%% Solve the optimal value and policy function
tic

[policy policyopt v X R wp] = findpolicy_yield_stoch(n,beta,r,P,c0,c1,ps,pc,A,rec,S,re,max_k,min_k,tol,maxit);

for i=1:size(X,2);
    for j=1:size(r,2);
    t=X(i);
 policy_myop(i,j)=fminsearch(@(w) -pi_total_yield(w,r(j),c0,c1,ps,pc,irrig(A,max_k,min_k,t),A,t),.1);
    end
end



%% iteration


%Iterate it through time
for z=1:55;
j=500   %nubmer of years;
xstart=790 %initial level;
x=zeros(1,j) ;
x2=zeros(1,j) ;
x(1)=xstart;
x2(1)=xstart;
optimw= zeros(size(x));
myop= zeros(size(x));

rn=randsample(r,j,true); %random draws for rainfall realizations;


for i=1:j;
   
    %if(x(i) <= .0000000001);
     %    fprintf('zero');
     %    break;
   % end;
    
    optimw(i)=policyopt(x(i),rn(i));
    %if (optimw(i)<0);
   %  optimw(i)=0   ;
   % end
    
    
    myop(i)=  fminsearch(@(w) - pi_total_yield(w,rn(i),c0,c1,ps,pc,irrig(A,max_k,min_k,x2(i)),A,x2(i)),.1); 

    x(i+1)= x(i) + eom2(rec,re,optimw(i),irrig(A,max_k,min_k,x(i)),S); %move stock forward
    x2(i+1)= x2(i) +  eom2(rec,re,myop(i),irrig(A,max_k,min_k,x2(i)),S);
   
end

%% Get benefits
for i=1:j
    
    benefitopt(i)=  exp(-(1-beta)*i)*pi_total_yield(optimw(i),rn(i),c0,c1,ps,pc,irrig(A,max_k,min_k,x(i)),A,x(i));
    benefitmyop(i)=  exp(-(1-beta)*i)* pi_total_yield(myop(i),rn(i),c0,c1,ps,pc,irrig(A,max_k,min_k,x2(i)),A,x2(i));
  
end


benefitopttot(z)=sum(benefitopt)
benefitmyoptot(z)=sum(benefitmyop)
ratio(z)=benefitopttot/benefitmyoptot

xx(:,z)=x;
xx2(:,z)=x2;


end
ElapsedTime= toc/60
plot(x)
hold on
plot(x2)


%% plots to make



plot(X,irrig(A,max_k,min_k,X).*policy);
hold on
plot(X,irrig(A,max_k,min_k,X).*policy_myop);

plot(X,policy(1:492))
hold on
%plot(X,policy_myop)

h = datestr(clock,0);
save(['stoch_yield',h(1:11),'-',h(13:14),'-',h(16:17),'-',h(19:20)]);