
%% Iteration AR(1)

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
maxit = 500; % maximum number of loop iterations for value function convergence
n=500 %Grid space over stock

r=[.48 r 1.57]
[prob]= [.5 .25 .25 ; .25 .5 .25; .25 .25 .5]'

%% Solve the optimal value and policy function
tic
[policy policyopt v X R wp] = findpolicy_ar12(n,beta,r,k,g,c0,c1,A,rec,S,re,max_k,min_k,tol,maxit,prob);

for i=1:size(X,2);
    for j=1:size(r,2)
    t=X(i);
 policy_myop(i,j)=fminsearch(@(w) -u12(w,r(j),k,g,c0,c1,A,rec,S,re,max_k,min_k,irrig(A,max_k,min_k,t),t),0);
    end
end


%% iteration


%Iterate it through time
for z=1:55
j=500  ; %nubmer of years;


xstart=790 %initial level;
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

mean(rn);

for i=1:j;
   
    %if(x(i) <= .0000000001);
     %    fprintf('zero');
     %    break;
   % end;
    
    
    optimw(i)=policyopt(x(i),rn(i));
    %if (optimw(i)<0);
     %optimw(i)=0   ;
    %end;
    
    optimW(i)=optimw(i)*irrig(A,max_k,min_k,x2(i));
    
    myop(i)= fminsearch(@(w) -u12(w,rn(i),k,g,c0,c1,A,rec,S,re,max_k,min_k,irrig(A,max_k,min_k,x2(i)),x2(i)),0);
    myopW(i)=myop(i)*irrig(A,max_k,min_k,x2(i));

    x(i+1)= x(i)  + eom2(rec,re,optimw(i),irrig(A,max_k,min_k,x(i)),S); %move stock forward
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

xx(:,z)=x;
xx2(:,z)=x2;

end

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
save (['ar12',h(1:11),'-',h(13:14),'-',h(16:17),'-',h(19:20)]);

mean(ratio)
std(ratio)
mean(benefitopttot)
mean(benefitmyoptot)
mean(benefitopttot-benefitmyoptot)
std(benefitopttot-benefitmyoptot)
std(benefitopttot)
std(benefitmyoptot)
