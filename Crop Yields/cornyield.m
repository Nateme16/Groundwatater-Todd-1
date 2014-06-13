%% This is a crop yield function for corn%%

function [cyield] = cornyield(w,r,a,b,c,d);

ri=(r+w).*12;
cyield=a + b.*ri + c.*(ri.^2) + d.*(ri.^3);

end