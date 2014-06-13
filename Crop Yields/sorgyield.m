%% This is a crop yield function for sorgum%%

function [syield] = sorgyield(r,e,f,g,h);
ri=r.*12;
syield=e + f.*ri + g.*(ri.^2) + h.*(ri.^3);

end