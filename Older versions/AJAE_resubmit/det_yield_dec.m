function [ratio policyopt v X policy x x2 benefitopttot benefitmyoptot policy_myop optimw myop]=det_yield_dec(r,pc,ps,pw,farm,n,beta,c0,c1,A,rec,S,re,max_k,min_k,tol,maxit,init_k)


[policy policyopt v X R wp] = findpolicy_yield(n,beta,r,c0,c1,ps,pc,pw,A,rec,S,re,max_k,min_k,tol,maxit,farm,init_k);

for i=1:size(X,2);
    x=X(i);
 policy_myop(i)=fminsearch(@(w) -pi_total_yield(w,r,c0,c1,ps,pc,pw,A,x,farm,max_k,min_k,init_k),2);
end

%Iterate it through time

j=500   %nubmer of years;
xstart=init_k %initial level;
x=zeros(1,j) ;
x2=zeros(1,j) ;
x(1)=xstart;
x2(1)=xstart;
optimw= zeros(size(x));
myop= zeros(size(x));


for i=1:j;
   
    optimw(i)=policyopt(x(i));
 
    if (x2(i)>=min_k);
    myop(i)=  fminsearch(@(w) - pi_total_yield(w,r,c0,c1,ps,pc,pw,A,x2(i),farm,max_k,min_k,init_k),2); 
    %myop(i)= fmincon(@(w)  - pi_total_yield(w,r,c0,c1,ps,pc,pw,irrig(A,max_k,min_k,x2(i),farm,init_k),A,x2(i),farm),0,[],[],[],[],0,10)
        else
        myop(i)==0;
    end
   
    
    benefitopt(i)=  exp(-(1-beta)*i)*  pi_total_yield(optimw(i),r,c0,c1,ps,pc,pw,A,x(i),farm,max_k,min_k,init_k);
    benefitmyop(i)=  exp(-(1-beta)*i)* pi_total_yield(myop(i),r,c0,c1,ps,pc,pw,A,x2(i),farm,max_k,min_k,init_k);
  
    x(i+1)= x(i)  + eom2(rec,re,optimw(i),irrig(A,max_k,min_k,x(i),farm,init_k),S,farm); %move stock forward

    x2(i+1)= x2(i) +  eom2(rec,re,myop(i),irrig(A,max_k,min_k,x2(i),farm,init_k),S,farm);
end

benefitopttot=sum(benefitopt)
benefitmyoptot=sum(benefitmyop)
ratio=benefitopttot/benefitmyoptot

end
