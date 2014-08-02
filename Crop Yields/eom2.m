
%% This function takes the parameters of the aquifer and returns the Xdot or
%change in groundwater levels due to pumping and recharge
% rec- fixed recharge (acre feet)
%re- % of irrigation water returned to aquifer
%irr- irrigated acerage
%S- storativity (relates acre feet to change in height in feet)

function [xdot]= eom2(rec,re,w,irr,S,farm)

%if (w>=0)

xdot1=(rec+((re-1).*(w.*irr)))./((irr./farm).*S);

if (xdot1<4);
   xdot=xdot1;
else
    xdot=4;
end

%else
 %   xdot=(rec+((re-1).*(0.*irr)))./((irr./farm).*S);
%end


end
