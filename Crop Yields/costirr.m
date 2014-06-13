function [cost]=costirr(c0,c1,x,w);

cost=(c0+c1.*x).*w;

end