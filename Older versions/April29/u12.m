%% This function calculates aquifer wide profits sum of irrigated and dryland
%%  for 1 period

function [pi pi_irr pi_dry]=u12(w,r,k,g,c0,c1,A,rec,S,re,max_k,min_k,irr,x);

pi_dry= ((((r.^2)/(2.*k)) - (g.*r)./k)).*.5;

pi_irr= ((((r+w).^2)./(2.*k)) - ((g.*(r+w))./k)) - (c0+c1.*x).*w ; 
   
pi= pi_irr.*irr + (pi_dry).*(A-irr);

end