%Takes groundwater height in feet (above sea level) and translates it into 
%irrigated area in acers and dryland in acers

% A- total area of aquifer
%max_k- maximum level of aquifer
%min_k- minimum level of aquifer
%x- Aquifer height

function [irr dry]=irrig(A,max_k,min_k,x,farm)

if (x>=min_k);
H= max_k-(min_k);
h= x-(min_k);
a=A*43560 ;%converts acers into square feet
r= (a./pi).^(1/2); %radius of the surface area of cone
area = pi.*(h./(H./r)).^2; %area of cone above aquifer
areaf=farm*area;
irr=areaf./43560; %back to acers
dry=(A*farm)-irr;
%irr=A*farm;
%dry=(A*farm)-irr;

else
    irr=0;
    dry=(A*farm)-0;
end

end
