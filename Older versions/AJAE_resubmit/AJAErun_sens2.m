tic
clear all

beta = .96;   % discount factor
rd= 1.58   %average rain
pc=4.45
ps= 4.25
pw= 6.53

farm=.22195 %area of aquifer farmed 

c0=0  %fixed pump cost
c1=(.1044) %variable pump cost
A= 2190000 %Area of aquifer
rec=131400    %Aquifer Recharge
S=.17   %Storitivity
re=.2   %percent return
max_k = 3094; % max water level 
min_k = 2892;  % min water level  2892
init_k= 3069  %initial water level

tol = 1e-10; % convergence tolerance
maxit = 10000; % maximum number of loop iterations for value function convergence
n=1000; %Grid space over stock

V=conevolume((max_k-min_k),A)

irrig_base=irrig(A,max_k,min_k,max_k,farm,init_k)

sens=[2700:50:3050];
farm2=zeros(size(sens))

for i=1:size(sens,2)
As(i)=conevolume2(V,max_k-sens(i))

farm2(i) = irrig_base/As(i)
irrigcheck(i)=irrig(As(i),max_k,min_k,init_k,farm2(i),init_k)
end



ratio_s=zeros(size(sens));

xs=[2700:1:3069] ;

for i= 1:size(sens,2)
%% DETERMINISTIC

As2(i)=conevolume2(V,max_k-sens(i));

[ratio_d policyopt_d v_d X_d policy_d x_d x2_d benefitopttot_d benefitmyoptot_d policy_myop_d optimw_d myop_d]=det_yield_dec(rd,pc,ps,pw,farm2(i),n,beta,c0,c1,As2(i),rec,S,re,max_k,sens(i),tol,maxit,init_k);
ratio_s(i)= ratio_d
v_s(i,:)=v_d
X_dsens(i,:)=X_d

for ii=1:size(xs,2)
irrs(i,ii)=irrig(As2(i),max_k,sens(i),xs(ii),farm2(i),init_k);
end

end

for i=1:size(sens,2)
plot(X_dsens(i,:),v_s(i,:))
hold on

ind(i) = max(find(X_dsens(i,:)<init_k+5))
dist(i)= X_dsens(i,2) - X_dsens(i,1)


diffs(i)= (v_s(i,ind(i))-v_s(i,ind(i)-1))./(dist(i)*1)
end

for i=1:size(sens,2)
plot(X_dsens(i,:),irrig(As2(i),max_k,sens(i),X_dsens(i,:),farm2(i),init_k)./1e3)
hold on

end




toc
ElapsedTime= toc/60
h = datestr(clock,0);
%save(['AJAEfix',h(1:11),'-',h(13:14),'-',h(16:17),'-',h(19:20)]);
