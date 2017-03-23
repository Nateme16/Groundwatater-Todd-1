%% wwyield
%This is a crop yield function for winter wheat as a function of rainfall and 
%quadratic fit parameters

function [wwyield] = wwyield(r,aa,bb,cc,dd);

ri=r*12;%acre feet to inches both rainfall and irrigation
wwyield1=aa + bb.*ri + cc.*(ri.^2) + dd.*(ri.^3);

if (wwyield1<0);%limits to positive domain
    wwyield=0;
else 
    wwyield=wwyield1;
end


end