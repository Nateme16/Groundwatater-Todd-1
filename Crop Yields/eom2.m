
%% This function takes the parameters of the aquifer and returns the Xdot or
%change in groundwater levels due to pumping and recharge
% rec- fixed recharge (acre feet)
%re- % of irrigation water returned to aquifer
%irr- irrigated acerage
%S- storativity (relates acre feet to change in height in feet)

function [xdot]= eom2(rec,re,w,irr,S,farm)

if (w>=0)
xdot=(rec+((re-1).*(w.*irr)))./((irr./farm).*S);

else
    xdot=(rec+((re-1).*(0.*irr)))./((irr./farm).*S);
end



end
