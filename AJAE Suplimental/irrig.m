
%% Irrig
%Takes groundwater height in feet (above sea level) and translates it into irrigated area 
% in acres and dryland in acres existing above aquifer

% A- total area of aquifer in acres
% max_k- maximum level of aquifer (feet)
% min_k- minimum level of aquifer (feet)
% x- Aquifer height (feet)

function [irr dry dryinit]=irrig(A,max_k,min_k,x,farm,init_k)

if (x>=min_k );
H= init_k-(min_k);
h=x-(min_k);
a=A*43560 ;%converts acres into square feet
r= (a./pi).^(1/2); %radius of the surface area of cone
area = pi.*(h./(H./r)).^2; %surface area of cone remaining above aquifer in square feet

areainit=pi.*((init_k-(min_k))./(H./r)).^2; %initial area of possible dryland in square feet

dryinit=((a-areainit)*farm)./43560; %initial area of dryland farming with the % farmaland assumption taken into account

areaf=farm*area; %area of irrigated farming in square feet
irr=areaf./43560; %back to acres
dry=((farm*(a-area))./43560)-dryinit; %dryland area with initial dryland set to zero

else % boundary condition eliminating negative areas
    irr=.00000001;
    dry=(A*farm);
end
end
