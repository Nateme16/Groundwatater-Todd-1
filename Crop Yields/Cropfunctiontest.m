
clear all

a= -339.5043
b= 25.42806
c= -.2623373
d= -.0008401
e= -377.0589
f= 40.49327
g= -1.083639
h= .0095426

r=[0:.01:5];

cyield=cornyield(r,a,b,c,d);
syield=sorgyield(r,e,f,g,h);


plot(r,cyield)
hold on
plot(r,syield)

