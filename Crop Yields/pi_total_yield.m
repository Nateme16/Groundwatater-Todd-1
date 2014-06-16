function [pi_tot]=pi_total_yield(w,r,c0,c1,ps,pc,irrig,A,x);
farm=.12;
a= -339.5043;
b= 25.42806;
c= -.2623373;
d= -.0008401;
e= -377.0589;
f= 40.49327;
g= -1.083639;
h= .0095426;

pic= pc.*cornyield(w,r,a,b,c,d) - costirr(c0,c1,x,w);

pis= ps.*sorgyield(r,e,f,g,h);

pi_tot=pic.*irrig + pis.*((A*farm)-irrig) ;

end
