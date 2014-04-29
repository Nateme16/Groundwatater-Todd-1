function [policyopt valuefit alpha policy policyint v X u1 ] = findpolicyeom(n,beta,r,k,g,c0,c1,A,rec,S,re,max_k,min_k,tol,maxit)


%alpha=@(x) ((x-min_k)/(max_k-min_k))*A %area irrigated
alpha=@(x) (x/x)*A
Gamma =@(x) x + eom(rec,re,0,alpha(x),S)


benefit= @(w,x) ((((r+w).^2)./(2.*k)) - ((g.*(r+w))./k)) %Benefit of irrigation land
cost= @(w,x) (c0+c1.*x)*w %cost of irrigation
profitirr=@(w,x) benefit(w,x)-cost(w,x) % Profit irrigation
profitnonirr=(((r.^2)/(2.*k) )- ((g.*r)./k)) %Profit non-irrigated

u1=@(w,x) profitirr(w,x)*alpha(x) + profitnonirr*(A-alpha(x)) %profit area corrected together

X = linspace(min_k,max_k,n); % an evenly spaced grid

% pre-compute the return function on the entire grid of states and possible
% choice variables.
R = NaN(n,n);
for i = 1:n % loop over the water states;
    x = X(i);
    for j = 1:n % loop over next period's water states;
        y = X(j);
        
        R(i,j) = -Inf; % set the default return to negative infinity      
        % check to see if next period's water choice is feasible
        if(y <= Gamma(x)&&y>= min_k && y<= max_k);
            % if so, set the appropriate return
            R(i,j) = u1( ((Gamma(x)-y)./S)./alpha(x) ,x) ;% This is implicitly u1(w,x), where w is the difference between the hights in current and future correcting for storitivity and area, recharge, returned irrigation water
            wp(i,j)= ((Gamma(x)-y)./S)./alpha(x)   ; %policy matrix
        end
    end

end





%% Value function iteration loop
v = zeros(n,1); % initialize value function "guess" to zeros
tv = v; % pre-allocate space for the updated value function

% loop until either we converge or we hit the maximum number of iterations
for i=1:maxit
    % loop over all possible water states
    for j=1:n
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

%Recover the policy function


%%Interpolation Code

v(1)=v(2)-10e2 ;   %makes value at 0 water a very large negative number instead of -inf


valuefit=fit(X',v,'cubicinterp')  % interpolates cubic function to value function

valueint=@(w,x) -(u1(w,x) + beta.*valuefit(x + eom(rec,re,w,alpha(x),S))) % this is the function to optimize


for i=1:n; %loops over water levels
    x=X(i);
    
[policyint(i) fval(i)]= fminsearch(@(w)valueint(w,x),.2); % calculates optimal policy at levels

if(policyint(i)<=0);
    policyint(i)=0;
end
end


%% Show the results

subplot (2, 1, 1);
plot(X,valuefit(X)); % plot results
title('Optimal value for current elevation (from sea level)');
xlabel('Water Table Elevation');
ylabel('Present discounted value');

subplot (2, 1, 2);
plot(X(1:end),policyint)


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( X, policyint );

% Set up fittype and options.
ft = fittype( 'splineinterp' );
opts = fitoptions( ft );
opts.Normalize = 'on';

% Fit model to data.
policyopt= fit( xData, yData, ft, opts );

 plot(X,policyopt(X))
 hold on

end





