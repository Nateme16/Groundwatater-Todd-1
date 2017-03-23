%% This is a crop yield function for corn%%

function [cyield] = cornyield(w,r,a,b,c,d);

ri=(r+w).*12;
cyield1=a + b.*ri + c.*(ri.^2) + d.*(ri.^3);

if (cyield1<0);
    cyield=0;
else 
    cyield=cyield1;
end


end