
%% Iteration Stochastic Yield

%Finds optimal value function for parameters:
clear all
beta = .96;   % discount factor
r= 1.5833   %average rain

c0=104   %fixed pump cost
c1=-(104/943) %variable pump cost

pc=4.47
ps=4.25

A= 3110000   %Area of aquifer
rec=40*(A/625)    %Aquifer Recharge
S=.17   %Storitivity
re=.2   %percent returned irrigation water
max_k = 916; % max water level 
min_k = 741;  % min water level
tol = 1e-10; % convergence tolerance
maxit = 3000; % maximum number of loop iterations for value function convergence
n=10000 %Grid space over stock

r=[1.25 r 2]
[prob]= [.4 .31 .28 ; .21 .37 .40; .43 .25 .33]'

%% Solve the optimal value and policy function
tic
[policy policyopt v X R wp] = findpolicy_yield_AR1(n,beta,r,c0,c1,ps,pc,A,rec,S,re,max_k,min_k,tol,maxit,prob);


for i=1:size(X,2);
    for j=1:size(r,2)
    t=X(i);
 policy_myop(i,j)=fminsearch(@(w) -pi_total_yield(w,r(j),c0,c1,ps,pc,irrig(A,max_k,min_k,t),A,t),.1);
    end
end


%% iteration


%Iterate it through time
for z=1:2
j=500  ; %nubmer of years;


xstart=910 %initial level;
x=zeros(1,j) ;
x2=zeros(1,j) ;
x(1)=xstart;
x2(1)=xstart;
optimw= zeros(size(x));
myop= zeros(size(x));

rn(1)=randsample(r,1,true);

for i=1:j;% creates j length rainfall time series
    ind=randp(prob(:,find(r==rn(i)))',1,1);
    rn(i+1)=r(ind)   ;
end

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

%% plots to make

plot(xx)
hold on
plot(xx2)

%plot(X,irrig(A,max_k,min_k,X).*policy);
%hold on
%plot(X,irrig(A,max_k,min_k,X).*policy_myop);

%plot(X,policy)
%hold on
%plot(X,policy_myop)

ElapsedTime= toc/60

h = datestr(clock,0);
save (['ar1_yield',h(1:11),'-',h(13:14),'-',h(16:17),'-',h(19:20)]);