%% AJAErun_tab4
%
% This is a variation of AJAErun file.This file runs the program for estimating value functions, optimal policy
% function, time-paths of extraction, welfare estimates for myopic and
% optimal groundwater extraction. It was also used to make the results in
% Table 4. 
%
% It calls the following associated function files:
% irrig(.)   - Translates groundwater height to remaining irrigated aceerage
%             ("cone function")
%
% det_yield_dec(.)-  returns results of deterministic rainfall scenario
%
% raintime(.) - calculate non-conditional probabilities to the MC process 
%               rainfall realizations. Also Returns the average of the
%               process.
%
%in addition to this program package this process requires: 
%curve fitting toolbox,  optimization toolbox

tic
clear all

beta = .96;   % discount factor
pc=4.45
ps= 4.25
pw= 6.53

farm=.22195 %area of aquifer farmed (irrigated+dryland) This makes initial irriaged acres as 17% of A, and correct total. 

c0=0  %fixed pump cost
c1=(.1044) %variable pump cost
A= 2190000 %Area of aquifer
rec=131400    %Aquifer Recharge
S=.17   %Storitivity
re=.2   %percent return
max_k = 3094; % max water level 
min_k = 2892;  % min water level 
init_k= 3069  %initial water level

[irr dry dryinit]=irrig(A,max_k,min_k,init_k,farm,init_k)
conevolume(500,A)./dryinit

tol = 1e-10; % convergence tolerance
maxit = 10000; % maximum number of loop iterations for value function convergence
n=2000 %Grid space over stock
zn= 100

r=[1.25 1.58 2]

[prob]= [.4048 .3095 .2857 ; .2162 .3784 .4054; .4250 .2500 .3250]'

[P rd]=raintime(100000,prob,r)

[ratio_d policyopt_d v_d X_d policy_d x_d x2_d benefitopttot_d benefitmyoptot_d policy_myop_d optimw_d myop_d]=det_yield_dec(rd,pc,ps,pw,farm,n,beta,c0,c1,A,rec,S,re,max_k,min_k,tol,maxit,init_k);

mean(ratio_d)

j=500  ; %nubmer of years;
xstart=init_k; %initial level;
x2=zeros(1,j) ;
x4=zeros(1,j) ;
x2(1)=xstart;
x4(1)=xstart;
optimw= zeros(size(x2));
myop= zeros(size(x4));


for i=1:j;
    w_d(i)=policyopt_d(x4(i));

    myop(i)=  fminsearch(@(w) - pi_total_yield(w,rd,c0,c1,ps,pc,pw,A,x2(i),farm,max_k,min_k,init_k),2); 

    benefitmyop(i)=  exp(-(1-beta)*(i))* pi_total_yield(myop(i),rd,c0,c1,ps,pc,pw,A,x2(i),farm,max_k,min_k,init_k);

    benefit_d(i)=  exp(-(1-beta)*(i))* pi_total_yield(w_d(i),rd,c0,c1,ps,pc,pw,A,x4(i),farm,max_k,min_k,init_k);
 
    x2(i+1)= x2(i) +  eom2(rec,re,myop(i),irrig(A,max_k,min_k,x2(i),farm,init_k),S,farm);

    x4(i+1)= x4(i) +  eom2(rec,re,w_d(i),irrig(A,max_k,min_k,x4(i),farm,init_k),S,farm);
end

benefitmyoptot=sum(benefitmyop);

benefit_dtot=sum(benefit_d);

ratio_de=benefit_dtot/benefitmyoptot;


%for plots of per acre benefits split irr/dry and overall benefits
%accounting for acreage
clear xmyop xop irrig_myop dry_myop irrig_op dry_op pi_dry_myop pi_irr_myop pi_tot_myop pi_tot_op benefitmyop2 benefit_d2 
for i=1:size(x2,2)-1
[pi_tot_myop(i), pi_dry_myop(i), pi_irr_myop(i)]=pi_total_yield(myop(i),rd,c0,c1,ps,pc,pw,A,x2(i),farm,max_k,min_k,init_k);
[pi_tot_op(i), pi_dry_op(i), pi_irr_op(i)]=pi_total_yield(w_d(i),rd,c0,c1,ps,pc,pw,A,x4(i),farm,max_k,min_k,init_k);
end

plot(benefitmyop./1e6)
hold on 
plot(benefit_d./1e6)

%for table

nt=25
xmyop=x2(1:nt:length(x2))
xop=x4(1:nt:length(x4))

[irrig_myop dry_myop]=irrig(A,max_k,min_k,x2,farm,init_k)
[irrig_op dry_op]  =irrig(A,max_k,min_k,x4,farm,init_k)

irrig_myop=irrig_myop(1:nt:length(x2))
irrig_op=irrig_op(1:nt:length(x4))

dry_myop=dry_myop(1:nt:length(x2))
dry_op=dry_op(1:nt:length(x4))

pi_dry_myop=pi_dry_myop(1:nt:length(x2)-1)
pi_irr_myop=pi_irr_myop(1:nt:length(x4)-1)

pi_dry_op=pi_dry_op(1:nt:length(x2)-1)
pi_irr_op=pi_irr_op(1:nt:length(x4)-1)

pi_tot_myop=pi_tot_myop(1:nt:length(x2)-1)./1e6
pi_tot_op=pi_tot_op(1:nt:length(x4)-1)./1e6

benefitmyop2=benefitmyop./1e6
benefit_d2=benefit_d./1e6

benefitmyop2=benefitmyop2(1:nt:length(x4)-1)
benefit_d2=benefit_d2(1:nt:length(x4)-1)

plot(irrig(A,max_k,min_k,x2(1:end-1),farm,init_k).*myop)
hold on
plot(irrig(A,max_k,min_k,x4(1:end-1),farm,init_k).*w_d)


toc
ElapsedTime= toc/60
h = datestr(clock,0);
save(['AJAEfix',h(1:11),'-',h(13:14),'-',h(16:17),'-',h(19:20)],'v7.3');
