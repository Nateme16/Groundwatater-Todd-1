%% findpolicy_yield
% This function takes inputs from iteration file and returns optimal value
% and policy functions
%It calls the following associated function files:
%
%eom2(.) - Equation of motion. This function takes the parameters of the aquifer and returns 
%           the Xdot or change in groundwater levels due to pumping and recharge
%
%irrig(.)- Takes groundwater height in feet (above sea level) and translates it into irrigated area 
%
% pi_total_yield(.) - calculates one year's aquifer wide returns in total 
%                     and per irrigated and dryland acres
% requires curve fitting toolbox

function [policy policyopt v X R wp] = findpolicy_yield(n,beta,r,c0,c1,ps,pc,pw,A,rec,S,re,max_k,min_k,tol,maxit,farm,init_k)

%% Define payoff space (returns to pumping choice)
Gamma =@(x) x + eom2(rec,re,0,irrig(A,max_k,min_k,x,farm,init_k),S,farm); %limit next period's water levels
%

X = linspace(min_k+(min_k*0),max_k,n); % an evenly spaced grid over water levels
%
% pre-compute the return function on the entire grid of states and possible
% choice variables
R = NaN(n,n);
wp=zeros(n,n);
R=zeros(n,n);
for i = 1:n % loop over the water states;
    x = X(i);
    for j = 1:n % loop over next period's water states;
        y = X(j);
        R(i,j) = -inf; % set the default return to negative infinity      
        % check to see if next period's water choice is feasible
        if(y <= Gamma(x) && y>= min_k && y<= max_k);
        % if so, set the appropriate return and corresponding policy 
        
        % wp is policy (per irrigated acre) corresponding to grid space 
        % (the difference in heights adjusting for recharge and eom)
        wp(i,j)= (( ((x-y) - eom2(rec,re,0,irrig(A,max_k,min_k,x,farm,init_k),S,farm)) .*((irrig(A,max_k,min_k,x,farm,init_k)./farm)*S) )./(1-re)) ./ irrig(A,max_k,min_k,x,farm,init_k) ;
      
        R(i,j)=pi_total_yield(wp(i,j),r,c0,c1,ps,pc,pw,A,x,farm,max_k,min_k,init_k); %profit from choice of policy
        end
    end
end


%% Value function iteration loop
v = zeros(n,1); % initialize value function "guess" to zeros
tv = v; % pre-allocate space for the updated value function
% loop until either we converge or we hit the maximum number of iterations

R(R==-inf)=-5e100; %penalize non-feasible choices, but avoid -inf issues

for i=1:maxit
    for j=1:n  % loop over all possible water states
        % use the bellman mapping T(v) to map v into tv
        [tv(j) I(j)] = max(R(j,:) + beta .* v',[],'omitnan');
        policy(j)= wp(j,I(j));
    end
    
    % compute the "distance" between the old and new value functions
    diff = max(abs(tv - v));
    fprintf('Iteration %3d: %.6f\n',i,diff);

    % check for convergence
    if(diff < tol);
        fprintf('Value function iteration has converged.\n');
        break;
    end
    
    % update the old value function values with the new ones
    v = tv;
    
end
%fit curve to gridded points using linear interpolation
[xData, yData] = prepareCurveData( X, policy );

% Set up fittype and options.
ft = 'linearinterp';
opts = fitoptions( ft );
opts.Normalize = 'on';

% Fit model to data. return continuous policy function
[policyopt, gof] = fit( xData, yData, ft, opts );


end
