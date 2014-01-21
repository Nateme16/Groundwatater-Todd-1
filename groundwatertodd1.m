clear all;
close all;
clc;
beta = .96;   % discount factor
r=0   %average recharge
k=-.89  %Slope of demand curve
g=300  %Intercept of demand curve
c0=104    %fixed pump cost
c1=-.104  %variable pump cost
A=625



% maximum capital possible in this model
max_k = 3000;

alpha=@(x) (x/max_k)

% Gamma is the choice set for next period's capital given current capital
% holdings (x). We will use Gamma(x) to compute the return function to make
% sure our choice for next period's capital is feasible. I.e. y <= Gamma(x)

Gamma = @(x) x+r;

u1 = @(w,x) (((w+r).^2)/2.*k.*alpha(x) - (g.*(w+r))./k - (c0+c1.*x).*w) + (r.^2)/2.*k.*(1-alpha(x)) - (g.*r)./k ; % profit from water pumped (1 period)
%u2= @(x)  (r.^2)/2.*k.*alpha - (g.*r)./k  dyrland only

%w=[0:.1:100]  test of value function
%x=100
%u1(w,x)
%plot(ans)


%% Value function iteration parameters
tol = 1e-4; % convergence tolerance
maxit = 1000; % maximum number of loop iterations

n =500; % n specifies how fine our grid of capital holdings will be
X = linspace(0,max_k,n); % an evenly spaced grid

% pre-compute the return function on the entire grid of states and possible
% choice variables.
R = NaN(n,n);
for i = 1:n % loop over the capital states
    x = X(i);
    for j = 1:n % loop over next period's capital states
        y = X(j);
        
        R(i,j) = -Inf; % set the default return to negative infinity
        
        % check to see if next period's capital choice is feasible
        if(y <= Gamma(x))
            % if so, set the appropriate return
            R(i,j) = u1((x+r - y),x);
        end
    end
end


%% Value function iteration loop
v = zeros(n,1); % initialize value function "guess" to zeros
tv = v; % pre-allocate space for the updated value function

% loop until either we converge or we hit the maximum number of iterations
for i=1:maxit
    % loop over all possible capital states
    for j=1:n
        % use the bellman mapping T(v) to map v into tv
        tv(j) = max(R(j,:) + beta * v');
    end
    
    % compute the "distance" between the old and new value functions
    diff = max(abs(tv - v));
    fprintf('Iteration %3d: %.6f\n',i,diff);

    % check for convergence
    if(diff < tol)
        fprintf('Value function iteration has converged.\n');
        break;
    end
    
    % update the old value function values with the new ones
    v = tv;
end

%% Show the results
plot(X,v); % plot results
title('Optimal value for current capital');
xlabel('Capital');
ylabel('Present discounted value');

