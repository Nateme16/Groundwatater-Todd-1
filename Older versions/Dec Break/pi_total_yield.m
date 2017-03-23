function [pi_tot pis pic]=pi_total_yield(w,r,c0,c1,ps,pc,pw,irriga,A,x,farm);

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

if (w<-.0010)
   pi_tot=-inf;
else 
    
pic = pc.*cornyield(w,r,a,b,c,d) - costirr(c0,c1,x,w);


pis= (1/3).*(ps.*sorgyield(r,e,f,g,h))+ (1/3).*(pw.*wwyield(r,aa,bb,cc,dd));


pi_tot=pic.*irriga + pis.*((A*farm- 1.144203080580335e+05)-irriga) ;  % the number in here is to make initial dryland 0. NEEDS TO CHANGE BASED ON Farm %
end

%1.144203080580335e+05
end
