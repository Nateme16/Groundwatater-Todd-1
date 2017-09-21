%% sorgyield
%This is a sorghum yield function for corn as a function of rainfall and 
%quadratic fit parameters

function [syield] = sorgyield(r,e,f,g,h);
ri=r.*12;%acre feet of rainfall to inches
syield1=e + f.*ri + g.*(ri.^2) + h.*(ri.^3);

if (syield1<0);%limits to positive domain
    syield=0;
else 
    syield=syield1;
end


end