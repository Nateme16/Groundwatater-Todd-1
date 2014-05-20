
%% Iteration Stochastic

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
tol = 1e-4; % convergence tolerance
maxit = 3000; % maximum number of loop iterations for value function convergence
n=500 %Grid space over stock

r=[.48 r 1.57]
P=[ .25 .5 .25 ]

%% Solve the optimal value and policy function
tic
[policy policyopt v X R wp] = findpolicy_stoch2(n,beta,r,k,g,c0,c1,A,rec,S,re,max_k,min_k,tol,maxit,P);


for i=1:size(X,2);
    for j=1:size(r,2);
    t=X(i);
 policy_myop(i,j)=fminsearch(@(w) -u12(w,r(j),k,g,c0,c1,A,rec,S,re,max_k,min_k,irrig(A,max_k,min_k,t),t),0);
    end
end



%% iteration


%Iterate it through time
for z=1:3;
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
    
    
    myop(i)= fminsearch(@(w) -u12(w,rn(i),k,g,c0,c1,A,rec,S,re,max_k,min_k,irrig(A,max_k,min_k,x2(i)),x2(i)),0);
    

    x(i+1)= x(i) + eom2(rec,re,optimw(i),irrig(A,max_k,min_k,x(i)),S); %move stock forward
    x2(i+1)= x2(i) +  eom2(rec,re,myop(i),irrig(A,max_k,min_k,x2(i)),S);
   
end

%% Get benefits
for i=1:j
    
    benefitopt(i)=  exp(-(1-beta)*i)*  u12(optimw(i),rn(i),k,g,c0,c1,A,rec,S,re,max_k,min_k,irrig(A,max_k,min_k,x(i)),x(i));
    benefitmyop(i)=  exp(-(1-beta)*i)* u12(myop(i),rn(i),k,g,c0,c1,A,rec,S,re,max_k,min_k,irrig(A,max_k,min_k,x2(i)),x2(i));
end

benefitopttot(z)=sum(benefitopt)
benefitmyoptot(z)=sum(benefitmyop)
ratio(z)=benefitopttot/benefitmyoptot


ElapsedTime= toc/60
h = datestr(clock,0);

end
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

save(['stoch2',h(1:11),'-',h(13:14),'-',h(16:17),'-',h(19:20)]);