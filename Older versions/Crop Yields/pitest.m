clear all

a= -339.5043
b= 25.42806
c= -.2623373
d= -.0008401
e= -377.0589
f= 40.49327
g= -1.083639
h= .0095426

c0=104   %fixed pump cost
c1=-(104/1000) %variable pump cost

pc=4.4
ps=4.4


r=[0:.01:5];

w=0
x=750

pic=pc.*cornyield(w,r,a,b,c,d)-costirr(c0,c1,x,w)
pis=ps.*sorgyield(r,e,f,g,h)

plot(r,pic)
hold on
plot(r,pis)
