%% This is a crop yield function for sorgum%%

function [syield] = sorgyield(r,e,f,g,h);
ri=r.*12;
syield1=e + f.*ri + g.*(ri.^2) + h.*(ri.^3);

if (syield1<0);
    syield=0;
else 
    syield=syield1;
end


end