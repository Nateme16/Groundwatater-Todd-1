%% costirr
%
%calculates per acres cost of irrigation based on height ammount withdrawl
%and cost perameters c0 and c1
%

function [cost]=costirr(c0,c1,x,w);

cost=(c0+c1.*(3094-x)).*w;

end