function [policyopt valuefit alpha policy policyint v X] = findpolicy(n,beta,r,k,g,c0,c1,A,rec,S,re,max_k,min_k,tol,maxit)

alpha=@(x) ((x-min_k)/(max_k-min_k))*A

% Gamma is the choice set for next period's capital given current capital
% holdings (x). We will use Gamma(x) to compute the return function to make
% sure our choice for next period's capital is feasible. I.e. y <= Gamma(x)

Gamma = @(x) x + (1/(A*S))*rec;

u1 = @(w,x)  (((((r+w).^2)./2.*k) - ((g.*(r+w))./k) - (c0+c1.*x)*w)).*alpha(x) + A-alpha(x).*((r.^2)/(2.*k.* - (g.*r)./k)) ; % profit from water pumped (1 period)
%u2= @(x)  (r.^2)/2.*k.*alpha - (g.*r)./k  dyrland only



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


%%Interpolation Code

v(1)=v(2) ;   %makes value at 0 water a very large negative number instead of -inf


valuefit=fit(X',v,'smoothingspline')  % interpolates cubic function to value function

valueint=@(w,x) -(u1(w,x)+ beta.*valuefit((x + (rec + (re-1).*w.*alpha(x))./(A.*S)))) % this is the function to optimize

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
plot(X,policyint)

policyopt=fit(X',policyint','cubicinterp')


end





