%% This is a crop yield function for corn%%

function [wwyield] = wwyield(r,aa,bb,cc,dd);

ri=(r)*12;
wwyield1=aa + bb.*ri + cc.*(ri.^2) + dd.*(ri.^3);

if (wwyield1<0);
    wwyield=0;
else 
    wwyield=wwyield1;
end


end