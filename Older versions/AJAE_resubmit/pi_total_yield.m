function [pi_tot pis pic]=pi_total_yield(w,r,c0,c1,ps,pc,pw,A,x,farm,max_k,min_k,init_k)

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

%if (w<0)%.0010
 %  pi_tot=-5e10;
%else 
    
pic = pc.*cornyield(w,r,a,b,c,d) - costirr(c0,c1,x,w);


pis= (1/3).*(ps.*sorgyield(r,e,f,g,h))+ (1/3).*(pw.*wwyield(r,aa,bb,cc,dd));

[irr dry]=irrig(A,max_k,min_k,x,farm,init_k);

pi_tot=(pic.*irr) + (pis.*dry) ;
%end

end
