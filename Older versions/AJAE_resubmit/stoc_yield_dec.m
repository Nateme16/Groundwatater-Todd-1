function [ratio policyopt v X rnst policy xx xx2 benefitopttot benefitmyoptot policy_myop optimw myop]=stoc_yield_dec(r,P,pc,ps,pw,farm,n,beta,zn,c0,c1,A,rec,S,re,max_k,min_k,tol,maxit,init_k,R_ar,wp_ar)

[policy policyopt v X R wp] = findpolicy_yield_stoch(n,beta,r,P,c0,c1,ps,pc,pw,A,rec,S,re,max_k,min_k,tol,maxit,farm,init_k,R_ar,wp_ar);

for i=1:size(X,2);
    for j=1:size(r,2)
    t=X(i);
 policy_myop(i,j)=fminsearch(@(w) -pi_total_yield(w,r(j),c0,c1,ps,pc,pw,A,t,farm,max_k,min_k,init_k),2);
    end
end

%Iterate it through time

for z=1:zn;
j=500   %nubmer of years;
xstart=init_k %initial level;
x=zeros(1,j) ;
x2=zeros(1,j) ;
x(1)=xstart;
x2(1)=xstart;
optimw= zeros(size(x));
myop= zeros(size(x));

%rn=randsample(r,j,true); %random draws for rainfall realizations;
ind=randp(P,j,1);
rn=r(ind);

for i=1:j;
   
    optimw(i)=policyopt(x(i),rn(i));
    
    if (x2(i)>=min_k)
    myop(i)=  fminsearch(@(w) - pi_total_yield(w,rn(i),c0,c1,ps,pc,pw,A,x2(i),farm,max_k,min_k,init_k),2); 
    
    else
        myop(i)==0
    end
    
    benefitopt(i)=  exp(-(1-beta)*i)*pi_total_yield(optimw(i),rn(i),c0,c1,ps,pc,pw,A,x(i),farm,max_k,min_k,init_k);
    benefitmyop(i)=  exp(-(1-beta)*i)*pi_total_yield(myop(i),rn(i),c0,c1,ps,pc,pw,A,x2(i),farm,max_k,min_k,init_k);
  
    x(i+1)= x(i) + eom2(rec,re,optimw(i),irrig(A,max_k,min_k,x(i),farm,init_k),S,farm); %move stock forward
    x2(i+1)= x2(i) +  eom2(rec,re,myop(i),irrig(A,max_k,min_k,x2(i),farm,init_k),S,farm);
   
end

benefitopttot(z)=sum(benefitopt);
benefitmyoptot(z)=sum(benefitmyop);
ratio(z)=benefitopttot(z)/benefitmyoptot(z)

xx(:,z)=x;
xx2(:,z)=x2;
rnst(:,z)=rn;
clear rn x x2 benefitopt benefitmyop 

end

end