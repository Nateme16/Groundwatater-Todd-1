
%% Iteration Stochastic Yield

%Finds optimal value function for parameters:
clear all
beta = .96;   % discount factor
r= 1.6141   %average rain

c0=104   %fixed pump cost
c1=-(104/943) %variable pump cost

pc=4.47
ps=4.25
pw=

A= 3110000   %Area of aquifer
farm=.17  %area of aquifer farmed 
rec=40*(A/625)    %Aquifer Recharge
S=.17   %Storitivity
re=.2   %percent returned irrigation water
max_k = 943; % max water level 
min_k = 741;  % min water level
tol = 1e-10; % convergence tolerance
maxit = 4000; % maximum number of loop iterations for value function convergence
n=10000 %Grid space over stock

r=[1.25 r 2]
P=[0.3529    0.3106    0.3365]


%% Solve the optimal value and policy function
tic

[policy policyopt v X R wp] = findpolicy_yield_stoch(n,beta,r,P,c0,c1,ps,pc,pw,A,rec,S,re,max_k,min_k,tol,maxit,farm);

for i=1:size(X,2);
    for j=1:size(r,2)
    t=X(i);
 policy_myop(i,j)=fminsearch(@(w) -pi_total_yield(w,r(j),c0,c1,ps,pc,pw,irrig(A,max_k,min_k,t,farm),A,t,farm),2);
    end
end


%% iteration



%Iterate it through time
for z=1:20;
j=500   %nubmer of years;
xstart=915 %initial level;
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
    
    if (x2(i)>=min_k)
    myop(i)=  fminsearch(@(w) - pi_total_yield(w,rn(i),c0,c1,ps,pc,pw,irrig(A,max_k,min_k,x2(i),farm),A,x2(i),farm),2); 
    end
    
    benefitopt(i)=  exp(-(1-beta)*i)*pi_total_yield(optimw(i),rn(i),c0,c1,ps,pc,pw,irrig(A,max_k,min_k,x(i),farm),A,x(i),farm);
    benefitmyop(i)=  exp(-(1-beta)*i)* pi_total_yield(myop(i),rn(i),c0,c1,ps,pc,pw,irrig(A,max_k,min_k,x2(i),farm),A,x2(i),farm);
  
    
    x(i+1)= x(i) + eom2(rec,re,optimw(i),irrig(A,max_k,min_k,x(i),farm),S,farm); %move stock forward
    x2(i+1)= x2(i) +  eom2(rec,re,myop(i),irrig(A,max_k,min_k,x2(i),farm),S,farm);
   
end


benefitopttot(z)=sum(benefitopt)
benefitmyoptot(z)=sum(benefitmyop)
ratio(z)=benefitopttot/benefitmyoptot

xx(:,z)=x;
xx2(:,z)=x2;



end

%% plots to make

plot(xx)
hold on
plot(xx2)

plot(X,policy'.*repmat(irrig(A,max_k,min_k,X,farm),size(r,2),1))

%plot(X,irrig(A,max_k,min_k,X,farm).*policy);
%hold on
%plot(X,irrig(A,max_k,min_k,X,farm).*policy_myop);

%plot(X,policy)
%hold on
%plot(X,policy_myop)

ElapsedTime= toc/60

h = datestr(clock,0);
save(['stoch_yield',h(1:11),'-',h(13:14),'-',h(16:17),'-',h(19:20)]);