function [A]= conevolume2(V,x)

r = (( (3*V) /(pi*x) )^(1/2))

A= pi*(r^2) 
A=A*2.2957e-5

end
