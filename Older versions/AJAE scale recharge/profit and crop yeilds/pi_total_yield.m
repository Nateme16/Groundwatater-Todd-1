%% pi_total_yield
%calculates one year's aquifer wide returns in total
%and per irrigated and dryland acres

%It calls the following functions:
% cornyield(w,r,a,b,c,d) - corn yield as a function of rainfall
% sorgyield(r,e,f,g,h)- sorghum yield as a function of rainfall
% wwyield(r,aa,bb,cc,dd)- winter wheat yield as a function of rainfall
%
% costirr(c0,c1,x,w) - cost of irrigation based on withdrawl and groundawter height
% irrig(.)- Takes groundwater height in feet (above sea level) and translates it into irrigated area 


function [pi_tot pis pic]=pi_total_yield(w,r,c0,c1,ps,pc,pw,A,x,farm,max_k,min_k,init_k)
%hard coded parameters of quadradic crop yeild functions
a= -339.5043;
b= 25.42806;
c= -.2623373;
d= -.0008401;

e=-75.5065;
f= 1.332312;
g= .4960935;
h= -.010717;

aa=-8.834491;
bb=4.929122;
cc=-.1062;
dd=.0008356;


pic = pc.*cornyield(w,r,a,b,c,d) - costirr(c0,c1,x,w);%per acre return from irrigated farmland

pis= (1/3).*(ps.*sorgyield(r,e,f,g,h))+ (1/3).*(pw.*wwyield(r,aa,bb,cc,dd));%per acre return from dryland 1/3 sorghum, 1/3 winter wheat, 1/3 fallow

[irr dry]=irrig(A,max_k,min_k,x,farm,init_k);

pi_tot=(pic.*irr) + (pis.*dry) ; %total returns aquifer wide

end
