%% FIND POLICY SIMPLE
%This function takes inputs from iteration file and returns optimal value
% and policy functions

function [policy v X R wp] = findpolicy_simple2(n,beta,r,k,g,c0,c1,A,rec,S,re,max_k,min_k,tol,maxit)

%% Define payoff space (returns to pumping choice)
Gamma =@(x) x + eom2(rec,re,0,irrig(A,max_k,min_k,x),S); %limit next period's water levels

X = linspace(min_k,max_k,n); % an evenly spaced grid over water levels

% pre-compute the return function on the entire grid of states and possible
% choice variables
R = NaN(n,n);

for i = 1:n % loop over the water states;
    x = X(i);
    for j = 1:n % loop over next period's water states;
        y = X(j);
        
        R(i,j) = -Inf; % set the default return to negative infinity      
        % check to see if next period's water choice is feasible
        if(y <= Gamma(x)&&y>= min_k && y<= max_k);
            % if so, set the appropriate return and corresponding policy 
        wp(i,j)= (((y-x) + eom2(rec,re,0,irrig(A,max_k,min_k,x),S)).*(irrig(A,max_k,min_k,x)*S) )./irrig(A,max_k,min_k,x) ;  % Policy (per irrigated acre) corresponding to grid space
        R(i,j)=u12(wp(i,j),r,k,g,c0,c1,A,rec,S,re,max_k,min_k,irrig(A,max_k,min_k,x),x); %profit from choice of policy
        end
    end
end


%% Value function iteration loop
v = zeros(n,1); % initialize value function "guess" to zeros
tv = v; % pre-allocate space for the updated value function

% loop until either we converge or we hit the maximum number of iterations

for i=1:maxit
  
    for j=1:n  % loop over all possible water states
        % use the bellman mapping T(v) to map v into tv
        [tv(j) I(j)] = max(R(j,:) + beta.* v');
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


end
