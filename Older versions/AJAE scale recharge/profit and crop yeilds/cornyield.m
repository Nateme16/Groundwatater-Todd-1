%% cornyield
%This is a crop yield function for corn as a function of rainfall and 
%quadratic fit parameters

function [cyield] = cornyield(w,r,a,b,c,d);

ri=(r+w).*12; %acre feet to inches both rainfall and irrigation
cyield1=a + b.*ri + c.*(ri.^2) + d.*(ri.^3);

if (cyield1<0); %limits to positive domain
    cyield=0;
else 
    cyield=cyield1;
end

end