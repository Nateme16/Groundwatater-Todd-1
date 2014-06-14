%% FIND POLICY SIMPLE
%This function takes inputs from iteration file and returns optimal value
% and policy functions

function [policy policyopt v X R wp] = findpolicy_yield_stoch(n,beta,r,P,c0,c1,ps,pc,A,rec,S,re,max_k,min_k,tol,maxit)

%% Define payoff space (returns to pumping choice)
Gamma =@(x) x + eom2(rec,re,0,irrig(A,max_k,min_k,x),S); %limit next period's water levels

X = linspace(min_k+(min_k*.15),max_k,n); % an evenly spaced grid over water levels

% pre-compute the return function on the entire grid of states and possible
% choice variables

R=zeros(n,n,size(r,1));
for i = 1:n % loop over the water states;
    x = X(i);
    for j = 1:n % loop over next period's water states;
        y = X(j);
        
        for e=1:size(r,2)
        R(i,j,e) = -inf; % set the default return to negative infinity      
        % check to see if next period's water choice is feasible
        if(y <= Gamma(x) && y>= min_k && y<= max_k)% && 0<=((((x-y) - eom2(rec,re,0,irrig(A,max_k,min_k,x),S)).*(irrig(A,max_k,min_k,x)*S) )./(1-re))./irrig(A,max_k,min_k,x));
          
            % if so, set the appropriate return and corresponding policy 
        wp(i,j,e)= ((((x-y) - eom2(rec,re,0,irrig(A,max_k,min_k,x),S)).*(irrig(A,max_k,min_k,x)*S) )./(1-re))./irrig(A,max_k,min_k,x) ;% Policy (per irrigated acre) corresponding to grid space
        eomtest(i,j,e)=eom2(rec,re,0,irrig(A,max_k,min_k,x),S);
       
        
        R(i,j,e)=pi_total_yield(wp(i,j,e),r(e),c0,c1,ps,pc,irrig(A,max_k,min_k,x),A,x); %profit from choice of policy
        end
        end
      
        
    end
end



%% Value function iteration loop
v = zeros(n,size(r,2)); % initialize value function "guess" to zeros
tv = v; % pre-allocate space for the updated value function
% loop until either we converge or we hit the maximum number of iterations

for i=1:maxit
    % loop over all possible capital states
    for j=1:n
        % use the bellman mapping T(v) to map v into tv
        for e=1:size(r,2)
            
        [tv(j,e) I(j,e)] = max(R(j,:,e) + (beta.* v*P')');
        policy(j,e)= wp(j,I(j,e));
        end
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

%% Fit: 'untitled fit 1'.

[xData, yData, zData] = prepareSurfaceData( X, r, policy );

% Set up fittype and options.
ft = 'linearinterp';
opts = fitoptions( ft );
opts.Normalize = 'on';

% Fit model to data.
[policyopt, gof] = fit( [xData, yData], zData, ft, opts );


end
