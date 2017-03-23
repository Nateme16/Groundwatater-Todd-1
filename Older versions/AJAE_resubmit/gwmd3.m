tic
clear all

beta = .96;   % discount factor
rd= 1.58   %average rain
pc=4.45
ps= 4.25
pw= 6.53

farm=.2281 %area of aquifer farmed NOTE NEED TO WATCH INITIAL DRYLAND FIX IN PROFIT FILE. 

c0=0  %fixed pump cost
c1=(.1044) %variable pump cost
A= 5722000 %Area of aquifer
rec=177954    %Aquifer Recharge
S=.17   %Storitivity
re=.2   %percent return
max_k = 3094; % max water level 
min_k = 2594;  % min water level 
init_k= 3069  %initial water level

[irr dry dryinit]=irrig(A,max_k,min_k,init_k,farm,init_k)

conevolume(500,A)./dryinit

tol = 1e-10; % convergence tolerance
maxit = 10000; % maximum number of loop iterations for value function convergence
n=10000 %Grid space over stock
zn= 100

r=[1.25 rd 2]
%r=[.1 2 3]
%% AR_1
[prob]= [.4048 .3095 .2857 ; .2162 .3784 .4054; .4250 .2500 .3250]'

%[prob]= [.9 .05 .05 ; .05 .9 .05; .05 .05 .9]'

[ratio_ar policyopt_ar v_ar X_ar rnar policy_ar xx_ar xx2_ar benefitopttot_ar benefitmyoptot_ar policy_myop_ar optimw_ar myop_ar R_ar wp_ar]=ar1_yield_dec(r,prob,pc,ps,pw,farm,n,beta,zn,c0,c1,A,rec,S,re,max_k,min_k,tol,maxit,init_k);

%% STOCHASTIC
%P=mean(histc(rnar,r,1)./size(rnar,1),2)'
%P=[.3529 .3110 .3361]
%P=[.9 .05 .05]
%P=[.3513 .3134 .3351]

[P rd]=raintime(100000,prob,r)

[ratio_st policyopt_st v_st X_st rnst policy_st xx_st xx2_st benefitopttot_st benefitmyoptot_st policy_myop_st optimw_st myop_st]=stoc_yield_dec(r,P,pc,ps,pw,farm,n,beta,zn,c0,c1,A,rec,S,re,max_k,min_k,tol,maxit,init_k,R_ar,wp_ar);
ptest=mean(histc(rnst,r,1)./size(rnst,1),2)'
meantest=mean(mean(rnst))

%% DETERMINISTIC
%rd=mean(mean(rnar))
[ratio_d policyopt_d v_d X_d policy_d x_d x2_d benefitopttot_d benefitmyoptot_d policy_myop_d optimw_d myop_d]=det_yield_dec(rd,pc,ps,pw,farm,n,beta,c0,c1,A,rec,S,re,max_k,min_k,tol,maxit,init_k);


mean(ratio_st)
mean(ratio_ar)
mean(ratio_d)

%% Expectation iteration

%Iterate it through time
for z=1:zn
j=500  ; %nubmer of years;


xstart=init_k; %initial level;
x=zeros(1,j) ;
x2=zeros(1,j) ;
x3=zeros(1,j) ;
x4=zeros(1,j) ;

x(1)=xstart;
x2(1)=xstart;
x3(1)=xstart;
x4(1)=xstart;
optimw= zeros(size(x));
myop= zeros(size(x));

rn(1)=randsample(r,1,true);

for i=1:j;% creates j length rainfall time series
    ind=randp(prob(:,find(r==rn(i)))',1,1);
    rn(i+1)=r(ind)  ;
end

for i=1:j;
   
    %if(x(i) <= .0000000001);
     %    fprintf('zero');
     %    break;
   % end;
    
    optimw(i)=policyopt_ar(x(i),rn(i));
    w_st(i)=policyopt_st(x3(i),rn(i));
    w_d(i)=policyopt_d(x4(i));
    %if (optimw(i)<0);
   %  optimw(i)=0   ;
   % end
    
    
    myop(i)=  fminsearch(@(w) - pi_total_yield(w,rn(i),c0,c1,ps,pc,pw,irrig(A,max_k,min_k,x2(i),farm,init_k),A,x2(i),farm),2); 

    benefitopt(i)=  exp(-(1-beta)*i)*pi_total_yield(optimw(i),rn(i),c0,c1,ps,pc,pw,irrig(A,max_k,min_k,x(i),farm,init_k),A,x(i),farm);
    benefitmyop(i)=  exp(-(1-beta)*i)* pi_total_yield(myop(i),rn(i),c0,c1,ps,pc,pw,irrig(A,max_k,min_k,x2(i),farm,init_k),A,x2(i),farm);
    benefit_st(i)=  exp(-(1-beta)*i)* pi_total_yield(w_st(i),rn(i),c0,c1,ps,pc,pw,irrig(A,max_k,min_k,x3(i),farm,init_k),A,x3(i),farm);
    benefit_d(i)=  exp(-(1-beta)*i)* pi_total_yield(w_d(i),rn(i),c0,c1,ps,pc,pw,irrig(A,max_k,min_k,x4(i),farm,init_k),A,x4(i),farm);

     x(i+1)= x(i) + eom2(rec,re,optimw(i),irrig(A,max_k,min_k,x(i),farm,init_k),S,farm); %move stock forward
   x2(i+1)= x2(i) +  eom2(rec,re,myop(i),irrig(A,max_k,min_k,x2(i),farm,init_k),S,farm);
   x3(i+1)= x3(i) +  eom2(rec,re,w_st(i),irrig(A,max_k,min_k,x3(i),farm,init_k),S,farm);
   x4(i+1)= x4(i) +  eom2(rec,re,w_d(i),irrig(A,max_k,min_k,x4(i),farm,init_k),S,farm);
end


benefitopttot(z)=sum(benefitopt);
benefitmyoptot(z)=sum(benefitmyop);
benefit_sttot(z)=sum(benefit_st);
benefit_dtot(z)=sum(benefit_d);

ratio_are(z)=benefitopttot(z)/benefitmyoptot(z);
ratio_ste(z)=benefit_sttot(z)/benefitmyoptot(z);
ratio_de(z)=benefit_dtot(z)/benefitmyoptot(z);

xx(:,z)=x;
xx2(:,z)=x2;
xx3(:,z)=x3;
xx4(:,z)=x4;
rnexp(:,z)=rn;
%clear rn  x2 x3 x4 benefitopt benefitmyop benefit_st benefit_d x
end


%% plots to make

plot(X_d,policy_d.*irrig(A,max_k,min_k,X_d,farm,init_k)./1e3)
hold on
plot(X_st,policy_st'.*repmat(irrig(A,max_k,min_k,X_st,farm,init_k),size(r,2),1)./1e3)
hold on
plot(X_ar,policy_ar'.*repmat(irrig(A,max_k,min_k,X_ar,farm,init_k),size(r,2),1)./1e3)

plot(X_d,policy_myop_d.*irrig(A,max_k,min_k,X_d,farm,init_k)./1e3)
hold on
plot(X_st,policy_myop_st'.*repmat(irrig(A,max_k,min_k,X_st,farm,init_k),size(r,2),1)./1e3)
plot(X_ar,policy_myop_ar'.*repmat(irrig(A,max_k,min_k,X_ar,farm,init_k),size(r,2),1)./1e3)

 %plot(X_st,((policy_st-policy_myop_st)./policy_myop_st)')

toc
ElapsedTime= toc/60
h = datestr(clock,0);
save(['AJAE_gmd3',h(1:11),'-',h(13:14),'-',h(16:17),'-',h(19:20)]);
