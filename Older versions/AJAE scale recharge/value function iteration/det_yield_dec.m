%% det_yield_dec
% returns results of aquifer simulation for the deterministic rainfall scenario
%
% It calls the following associated function files:
%
% findpolicy_yield_dec(.)- value function iteration process. Returns
%                          optimal policy function and value function
%
% pi_total_yield(.) - calculates one year's aquifer wide returns in total 
%                     and per irrigated and dryland acres
%
% eom2(.) - Equatio of motion. This function takes the parameters of the aquifer and returns 
%           the Xdot or change in groundwater levels due to pumping and recharge
%
% inputs variables are all from and defined in AJAE run

function [ratio policyopt v X policy x x2 benefitopttot benefitmyoptot policy_myop optimw myop]=det_yield_dec(r,pc,ps,pw,farm,n,beta,c0,c1,A,rec,S,re,max_k,min_k,tol,maxit,init_k)
%value function iteration process. Returns optimal policy function and value function
[policy policyopt v X R wp] = findpolicy_yield(n,beta,r,c0,c1,ps,pc,pw,A,rec,S,re,max_k,min_k,tol,maxit,farm,init_k);

%creates myopic policy function
for i=1:size(X,2);
    x=X(i);
 policy_myop(i)=fminsearch(@(w) -pi_total_yield(w,r,c0,c1,ps,pc,pw,A,x,farm,max_k,min_k,init_k),2);
end

%Iterates both policies through time to return welfare estimates

j=500 ;  %nubmer of years;
xstart=init_k %initial level;
x=zeros(1,j) ;
x2=zeros(1,j) ;
x(1)=xstart;
x2(1)=xstart;
optimw= zeros(size(x));
myop= zeros(size(x));


for i=1:j;
   
    optimw(i)=policyopt(x(i)); % returns optimal pumping choice at current groundwater height 
 
    if (x2(i)>=min_k);
    myop(i)=  fminsearch(@(w) - pi_total_yield(w,r,c0,c1,ps,pc,pw,A,x2(i),farm,max_k,min_k,init_k),2);  % returns myopic pumping choice at current groundwater height
        else
        myop(i)==0;
    end
   
    %calculates discounted sum of benefits for each year for both optimal
    %and myopic extraction
    
    benefitopt(i)=  exp(-(1-beta)*i)*  pi_total_yield(optimw(i),r,c0,c1,ps,pc,pw,A,x(i),farm,max_k,min_k,init_k);
    benefitmyop(i)=  exp(-(1-beta)*i)* pi_total_yield(myop(i),r,c0,c1,ps,pc,pw,A,x2(i),farm,max_k,min_k,init_k);
    
    %move stock forward based on equation of motion
    x(i+1)= x(i)  + eom2(rec,re,optimw(i),irrig(A,max_k,min_k,x(i),farm,init_k),S,farm); %move stock forward
    x2(i+1)= x2(i) +  eom2(rec,re,myop(i),irrig(A,max_k,min_k,x2(i),farm,init_k),S,farm);
end
%sums discounted benefits of both optimal and myopic
benefitopttot=sum(benefitopt);
benefitmyoptot=sum(benefitmyop);

%welfare ratio
ratio=benefitopttot/benefitmyoptot;

end
