%% FIND POLICY SIMPLE
%This function takes inputs from iteration file and returns optimal value
% and policy functions

function [policy policyopt v X R wp] = findpolicy_yield(n,beta,r,c0,c1,ps,pc,A,rec,S,re,max_k,min_k,tol,maxit)

%% Define payoff space (returns to pumping choice)
Gamma =@(x) x + eom2(rec,re,0,irrig(A,max_k,min_k,x),S); %limit next period's water levels

X = linspace(min_k+(min_k*.10),max_k,n); % an evenly spaced grid over water levels

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
        if(y <= Gamma(x) && y>= min_k && y<= max_k)% && 0<=((((x-y) - eom2(rec,re,0,irrig(A,max_k,min_k,x),S)).*(irrig(A,max_k,min_k,x)*S) )./(1-re))./irrig(A,max_k,min_k,x));
            % if so, set the appropriate return and corresponding policy 
        wp(i,j)= ((((x-y) - eom2(rec,re,0,irrig(A,max_k,min_k,x),S)).*((irrig(A,max_k,min_k,x)./.12)*S) )./(1-re))./irrig(A,max_k,min_k,x) ;% Policy (per irrigated acre) corresponding to grid space
        eomtest(i,j)=eom2(rec,re,0,irrig(A,max_k,min_k,x),S);
        % if (wp(i,j)<0);
           % wp(i,j)=0;
         %end
        
        R(i,j)=pi_total_yield(wp(i,j),r,c0,c1,ps,pc,irrig(A,max_k,min_k,x),A,x); %profit from choice of policy
        
        %if (wp(i,j)<0);
        %    R(i,j)=-inf;
       %end
        
        end
    end
end


%% Value function iteration loop
v = zeros(n,1); % initialize value function "guess" to zeros
tv = v; % pre-allocate space for the updated value function
% loop until either we converge or we hit the maximum number of iterations
%R(R==-inf)=0;
for i=1:maxit
  
    for j=1:n  % loop over all possible water states
        % use the bellman mapping T(v) to map v into tv
        
        [tv(j) I(j)] = max(R(j,:) + beta .* v');
      
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

%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( X, policy );

% Set up fittype and options.
ft = 'linearinterp';
opts = fitoptions( ft );
opts.Normalize = 'on';

% Fit model to data.
[policyopt, gof] = fit( xData, yData, ft, opts );


end
