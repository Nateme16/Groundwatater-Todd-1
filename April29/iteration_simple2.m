
%% Iteration Simple

%Finds optimal value function for parameters:
clear all
beta = .96;   % discount factor
r= 1.03   %average rain
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
tol = 1e-10; % convergence tolerance
maxit = 3000; % maximum number of loop iterations for value function convergence
n=100 %Grid space over stock

%% Solve the optimal value and policy function
tic
[policy policyopt v X R wp] = findpolicy_simple2(n,beta,r,k,g,c0,c1,A,rec,S,re,max_k,min_k,tol,maxit);

for i=1:size(X,2);
    x=X(i);
 policy_myop(i)=fminsearch(@(w) -u12(w,r,k,g,c0,c1,A,rec,S,re,max_k,min_k,irrig(A,max_k,min_k,x),x),0);
    
end


%% iteration


%Iterate it through time

j=1000   %nubmer of years;
xstart=790 %initial level;
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
    
    optimw(i)=policyopt(x(i));
    
    myop(i)= fminsearch(@(w) -u12(w,r,k,g,c0,c1,A,rec,S,re,max_k,min_k,irrig(A,max_k,min_k,x2(i)),x2(i)),0);
    

    x(i+1)= x(i) + + eom2(rec,re,optimw(i),irrig(A,max_k,min_k,x(i)),S); %move stock forward
    x2(i+1)= x2(i) +  eom2(rec,re,myop(i),irrig(A,max_k,min_k,x2(i)),S);
   
end

%% Get benefits
for i=1:j
    
    benefitopt(i)=  exp(-(1-beta)*i)*  u12(optimw(i),r,k,g,c0,c1,A,rec,S,re,max_k,min_k,irrig(A,max_k,min_k,x(i)),x(i));
    benefitmyop(i)=  exp(-(1-beta)*i)* u12(myop(i),r,k,g,c0,c1,A,rec,S,re,max_k,min_k,irrig(A,max_k,min_k,x2(i)),x2(i));
    
   [pio(i) pi_irro(i) pi_dryo(i)]  =u12(optimw(i),r,k,g,c0,c1,A,rec,S,re,max_k,min_k,irrig(A,max_k,min_k,x(i)),x(i));
   [pim(i) pi_irrm(i) pi_drym(i)] =u12(myop(i),r,k,g,c0,c1,A,rec,S,re,max_k,min_k,irrig(A,max_k,min_k,x2(i)),x2(i));
end

benefitopttot=sum(benefitopt)
benefitmyoptot=sum(benefitmyop)
ratio=benefitopttot/benefitmyoptot

%% plots to make

plot(x)
hold on
plot(x2)


plot(X,irrig(A,max_k,min_k,X).*policy);
hold on
plot(X,irrig(A,max_k,min_k,X).*policy_myop);

plot(X,policy)
hold on
plot(X,policy_myop)

ElapsedTime= toc/60

h = datestr(clock,0);
save(['det_2',h(1:11),'-',h(13:14),'-',h(16:17),'-',h(19:20)]);



plot(x(1:end-1),u12(myop,r,k,g,c0,c1,A,rec,S,re,max_k,min_k,irrig(A,max_k,min_k,x2(1:end-1)),x2(1:end-1)))
hold on
plot(x(1:end-1),u12(optimw,r,k,g,c0,c1,A,rec,S,re,max_k,min_k,irrig(A,max_k,min_k,x(1:end-1)),x(1:end-1)))
