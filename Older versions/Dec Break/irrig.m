%Takes groundwater height in feet (above sea level) and translates it into 
%irrigated area in acers and dryland in acers

% A- total area of aquifer
%max_k- maximum level of aquifer
%min_k- minimum level of aquifer
%x- Aquifer height

function [irr dry dryinit]=irrig(A,max_k,min_k,x,farm,init_k)
% irr=(A*farm-1.144203080580335e+05);
% dry=0;
% dryinit=0;


if (x>=min_k );
H= max_k-(min_k);
h=x-(min_k);
a=A*43560 ;%converts acers into square feet
r= (a./pi).^(1/2); %radius of the surface area of cone
area = pi.*(h./(H./r)).^2; %surface area of cone remaining above aquifer in square feet

areainit=pi.*((init_k-(min_k))./(H./r)).^2; %initial area of possible dryland area in square feet

dryinit=((a-areainit)*farm)./43560; %initial area of dryland farming with the "farm" assumption taken into account

areaf=farm*area; %area of irrigated farming in square feet
irr=areaf./43560; %back to acers
dry=((farm*(a-area))./43560)-dryinit;
%irr=3.9681e+05;
%dry=1.3189e+05;

else
    irr=.00000001;
    dry=(A*farm);
    
    %irr=3.9681e+05;
    %dry=1.3189e+05;
end

end
