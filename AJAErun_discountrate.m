%% AJAErun
%
% This file runs the program for estimating value functions, optimal policy
% function, time-paths of extraction, welfare estimates for myopic and
% optimal groundwater extraction
%
% It calls the following associated function files:
% irrig(.)   - Translates groundwater height to remaining irrigated aceerage
%             ("cone function")
%
% det_yield_dec(.)-  returns results of deterministic rainfall scenario
% stoc_yield_dec(.)- returns results of stochastic rainfall scenario
% ar1_yield_dec(.) - returns results of AR1 rainfall scenario
%
% raintime(.) - calculate non-conditional probabilities to the MC process 
%               rainfall realizations. Also Returns the average of the
%               process.
%
%in addition to this program package this process requires: 
%curve fitting toolbox,  optimization toolbox


tic
clear all

%% set parameters for simulation

pc=4.45 %price of corn
ps= 4.25%price of sorghum
pw= 6.53%price of winter wheat
farm=.22195 %area of aquifer farmed (irrigated+dryland) This makes initial 
            %irriaged acres as 17% of A, and correct total. 
            %the height of water is not at the initial height at the start,
            %but at 3069, making the initial area
            %smaller and thus a higher % farmed to get to the 373,200
            %irrigate acres.
c0=0          %fixed pump cost
c1=(.1044)    %variable pump cost
A= 2190000    %Area of aquifer
rec=131400    %Aquifer Recharge
S=.17         %Storitivity
re=.2         %percent return
max_k = 3094; % max water level
min_k = 2892; % min water level
init_k= 3069  %initial water level
r= 1.6052 %average rainfall from stochastic process

%check initial irrigated acerage
[irr dry dryinit]=irrig(A,max_k,min_k,init_k,farm,init_k)

tol = 1e-10; % convergence tolerance for value function iteration
maxit = 10000; % maximum number of loop iterations for value function convergence
n=1000 %Grid space over groundwater stock for value function iteration
zn= 1 % draws from stochastic process for summarizing results and standard errors
r=[1.25 1.58 2] % possible rainfall states in inches
[prob]= [.4048 .3095 .2857 ; .2162 .3784 .4054; .4250 .2500 .3250]' %Stochastic MC transition probabilities (from Table 2 in paper)
[P rd]=raintime(200000,prob,r) %returns non-conditional and average of the AR1 rainfall process

%% RUN SIMULATION

betai=[.99 .98 .97 .96 .95 .94 .93]

for i=1:size(betai,2)
   
beta = betai(i);   % discount factor

% DETERMINISTIC
[ratio_d policyopt_d v_d X_d policy_d x_d x2_d benefitopttot_d benefitmyoptot_d policy_myop_d optimw_d myop_d]=det_yield_dec(rd,pc,ps,pw,farm,n,beta,c0,c1,A,rec,S,re,max_k,min_k,tol,maxit,init_k);

%% Compare welfare gains across scenarios

meanbetai(i)=mean(ratio_d)

end

betai2=1-betai
plot(betai2*100,(meanbetai-1)*100)

%% save result 
h = datestr(clock,0);
save(['AJAEsupp_betai',h(1:11),'-',h(13:14),'-',h(16:17),'-',h(19:20)],'-V7.3');
