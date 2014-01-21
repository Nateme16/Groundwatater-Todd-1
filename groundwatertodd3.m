clear all;
close all;
clc;

tic
beta = .96;   % discount factor
r=1   %average rain
k=-.89  %Slope of demand curve
g=1.48  %Intercept of demand curve
c0=.1664   %fixed pump cost
c1=-.0001664  %variable pump cost
A= 625    %Area of aquifer
rec=40    %Aquifer Recharge
S=.17   %Storitivity
re=.2   %percent returned irrigation water


% maximum capital possible in this model
max_k = 800;
min_k = 400;
alpha=@(x) (x/max_k )*A

% Gamma is the choice set for next period's capital given current capital
% holdings (x). We will use Gamma(x) to compute the return function to make
% sure our choice for next period's capital is feasible. I.e. y <= Gamma(x)

Gamma = @(x) x + (1/(A*S))*rec;

u1 = @(w,x)  (((((r+w).^2)./2.*k) - ((g.*(r+w))./k) - (c0+c1.*x)*w)).*alpha(x) + A-alpha(x).*((r.^2)/(2.*k.* - (g.*r)./k)) ; % profit from water pumped (1 period)
%u2= @(x)  (r.^2)/2.*k.*alpha - (g.*r)./k  dyrland only

%w=[0:.01:1]  %test of value function;;
%x=100;
%u1(w,x);
%plot(w,ans);


%% Value function iteration parameters
tol = 1e-4; % convergence tolerance
maxit = 1000; % maximum number of loop iterations

n =1000; % n specifies how fine our grid of capital holdings will be
X = linspace(min_k,max_k,n); % an evenly spaced grid

% pre-compute the return function on the entire grid of states and possible
% choice variables.
R = NaN(n,n);
for i = 1:n % loop over the capital states;
    x = X(i);
    for j = 1:n % loop over next period's capital states;
        y = X(j);
        
        R(i,j) = -Inf; % set the default return to negative infinity
        
        % check to see if next period's capital choice is feasible
        if(y <= Gamma(x)&&y>= min_k && y<= max_k);
            % if so, set the appropriate return
            R(i,j) = u1( ((y-x).*(A.*S) - rec)./((re-1).*alpha(x)),x);% This is implicitly u1(w,x), where w is the difference between the hights in current and future correcting for storitivity and area, recharge, returned irrigation water
            wp(i,j)= ((y-x).*(A.*S) - rec)./((re-1).*alpha(x));
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
        [tv(j) I(j)] = max(R(j,:) + beta * v');
        
       % policy(1,j)= wp(j,I(j));
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

%Recover the policy function
for b=1:n;
    
    policy(1,b)=wp(b,I(b));
    
end;


%% Show the results
subplot (3, 1, 1);
plot(X,v); % plot results
title('Optimal value for current elevation (from sea level)');
xlabel('Water Table Elevation');
ylabel('Present discounted value');

subplot (3, 1, 2);
plot(X,policy)

subplot (3, 1, 3)
plot(X,alpha(X))

toc/60






