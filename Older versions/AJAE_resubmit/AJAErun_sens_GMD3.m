tic
clear all

beta = .96;   % discount factor
rd= 1.58   %average rain
pc=4.45
ps= 4.25
pw= 6.53

farm=.22195 %area of aquifer farmed 
farm3=.2281

c0=0  %fixed pump cost
c1=(.1044) %variable pump cost
A= 2190000 %Area of aquifer
A3= 5722000 %Area of aquifer gmd3
rec=131400
rec3= 177954  %Aquifer Recharge

S=.17   %Storitivity
re=.2   %percent return
max_k = 3094; % max water level 
min_k = 2892;  % min water level  2892
init_k= 3069  %initial water level

tol = 1e-10; % convergence tolerance
maxit = 10000; % maximum number of loop iterations for value function convergence
n=10000; %Grid space over stock



sens=[2594 2892];

for i=1:size(sens,2)
As(i)=conevolume2(V,max_k-sens(i))
end

V3=conevolume((max_k-sens(1)),A3)
V4=conevolume((max_k-sens(2)),A)

ratio_s=zeros(size(sens));

xs=[2550:1:3069] ;

As2=[A3 A]
farms=[farm3 farm]
recs=[rec3 rec]

irrig3=irrig(As2(1),max_k,sens(1),init_k,farm3,init_k)
irrig4=irrig(As2(2),max_k,sens(2),init_k,farm,init_k)

for i= 1:size(sens,2)
%% DETERMINISTIC
[ratio_d policyopt_d v_d X_d policy_d x_d x2_d benefitopttot_d benefitmyoptot_d policy_myop_d optimw_d myop_d]=det_yield_dec(rd,pc,ps,pw,farms(i),n,beta,c0,c1,As2(i),recs(i),S,re,max_k,sens(i),tol,maxit,init_k); %check penalty?
ratio_s(i)= ratio_d
v_s(i,:)=v_d
X_dsens(i,:)=X_d
policy_s(i,:)=policy_d
x_s(i,:)=x_d

for ii=1:size(xs,2)
irrs(i,ii)=irrig(As2(i),max_k,sens(i),xs(ii),farms(i),init_k);
end

end
plot(x_s')
plot(policy_s')


for i=1:size(sens,2)
plot(X_dsens(i,:),v_s(i,:))
hold on

diffv(i,:)=diff(v_s(i,:))

end


toc
ElapsedTime= toc/60
h = datestr(clock,0);
save(['AJAEfix_3v4',h(1:11),'-',h(13:14),'-',h(16:17),'-',h(19:20)]);
