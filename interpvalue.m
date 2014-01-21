function [gg]=interpvalue(x,v,X,n);

xlo=max(sum(x>X),1);


xhi= xlo+1;


gg= v(xlo) + (x-X(xlo)).*(v(xhi)-v(xlo))./(X(xhi)-X(xlo));



end
