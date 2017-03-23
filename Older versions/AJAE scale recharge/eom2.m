%% eom2
%This function takes the parameters of the aquifer and returns the Xdot or
%change in groundwater levels due to pumping and recharge
%
%inputs:
%rec- fixed recharge (acre feet)
%re- % of irrigation water returned to aquifer
%irr- irrigated acerage
%S- storativity (relates acre feet to change in height in feet)


function [xdot]= eom2(rec,re,w,irr,S,farm)

tr=(irr./farm)*rec;

xdot1=(tr+((re-1).*(w.*irr)))./((irr./farm).*S);

if (xdot1<=5); %limits infeasible hieght changes due to recharge at bottom of cone, boundary condition
  xdot=xdot1;
else
    xdot= 5; %limits infeasible hieght changes due to recharge at bottom of cone, boundary condition
end

end

