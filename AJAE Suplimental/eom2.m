%% eom2
%This function takes the parameters of the aquifer and returns the Xdot or
%change in groundwater levels due to pumping and recharge
%
%inputs:
%rec- fixed recharge (acre feet)
%re- % of irrigation water returned to aquifer
%irr- irrigated acerage
%S- storativity (relates acre feet to change in height in feet)
%farm is the % of initial area that is farmland of any type


function [xdot]= eom2(rec,re,w,irr,S,farm)

xdot1=(rec+((re-1).*(w.*irr)))./((irr./farm).*S);

if (xdot1<=5); %limits infeasible hieght changes due to recharge at bottom of cone, boundary condition
  xdot=xdot1;
else
    xdot= 5; %limits infeasible hieght changes due to recharge at bottom of cone, boundary condition
end

end

