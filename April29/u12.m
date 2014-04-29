%% This function calculates aquifer wide profits sum of irrigated and dryland
%%  for 1 period

function [pi]=u12(w,r,k,g,c0,c1,A,rec,S,re,max_k,min_k,irr,x)

pi=(  ((((r+w).^2)./(2.*k)) - ((g.*(r+w))./k)) - (c0+c1.*x)*w )*irr + ((((r.^2)/(2.*k) )- ((g.*r)./k)) )*(A-irr);

end