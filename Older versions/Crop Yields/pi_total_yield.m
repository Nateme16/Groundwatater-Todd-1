function [pi_tot pis pic]=pi_total_yield(w,r,c0,c1,ps,pc,pw,irrig,A,x,farm);

a= -339.5043;
b= 25.42806;
c= -.2623373;
d= -.0008401;
e= -286.4424;
f= 38.0334;
g= -1.5757;
h= .027195;

aa=128.3515;
bb=-17.21523;
cc=1.06818;
dd=-.01962;

if (w>=0)
    
pic = pc.*cornyield(w,r,a,b,c,d) - costirr(c0,c1,x,w);

else 
   pic=-10e10;
end

pis= (1/3).*(ps.*sorgyield(r,e,f,g,h))+ (1/3).*pw.*wwyield(r,aa,bb,cc,dd);

pi_tot=pic.*irrig + pis.*((A*farm)-irrig) ;

end
