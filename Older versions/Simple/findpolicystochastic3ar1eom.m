function [policyopt valuefit alpha policy policyint v X u1 ] = findpolicystochastic3eom(n,beta,r,k,g,c0,c1,A,rec,S,re,max_k,min_k,tol,maxit,prob)



alpha=@(x) ((x-min_k)/(max_k-min_k))*A %area irrigated
Gamma =@(x) x + eom(rec,re,0,alpha(x),S)


benefit= @(w,x,r) ((((r+w).^2)./(2.*k)) - ((g.*(r+w))./k)) %Benefit of irrigation
cost= @(w,x) (c0+c1.*x)*w %cost of irrigation
profitirr=@(w,x,r) (benefit(w,x,r)-cost(w,x)) % Profit Irrigation
profitnonirr=@(r) (((r.^2)/(2.*k) )- ((g.*r)./k)).*.3 %Prift non-irrigated

u1=@(w,x,r) profitirr(w,x,r)*alpha(x) + profitnonirr(r)*(A-alpha(x)) %profit area corrected together


X = linspace(min_k,max_k,n); % an evenly spaced grid

% pre-compute the return function on the entire grid of states and possible
% choice variables.

R = NaN(n,n,size(r,1));

for i = 1:n % loop over the capital states;
    x = X(i);
    for j = 1:n % loop over next period's capital states;
        y = X(j);
        for e=1:size(r,1) %loop over realizations of r
            
        
        R(i,j,e) = -Inf; % set the default return to negative infinity
        
        % check to see if next period's capital choice is feasible
        if(y <= Gamma(x)&&y>= min_k && y<= max_k);
            % if so, set the appropriate return
            R(i,j,e) = u1((y - x) + eom(rec,re,0,alpha(x),S) ,x, r(e) );% This is implicitly u1(w,x), where w is the difference between the hights in current and future correcting for storitivity and area, recharge, returned irrigation water
            wp(i,j,e)= (y - x) + eom(rec,re,0,alpha(x),S);
        end
        end
    end

end


%% Value function iteration loop
v = zeros(n,size(r,1)); % initialize value function "guess" to zeros
tv = v; % pre-allocate space for the updated value function

% loop until either we converge or we hit the maximum number of iterations
for i=1:maxit
    % loop over all possible capital states
    for j=1:n
        % use the bellman mapping T(v) to map v into tv
        for e=1:size(r,1)
        
        [tv(j,e) I(:,j)] = max(R(j,:,e)' + beta.* v*prob(:,e));
         
        end
        
        policy(1,j)= wp(j,I(j));
    end
    
    % compute the "distance" between the old and new value functions
    diff = max(abs(tv - v));
    %fprintf('Iteration %3d: %.6f\n',i,diff);

    % check for convergence
    if(diff < tol);
        fprintf('Value function iteration has converged.\n');
        break;
    end
    
    % update the old value function values with the new ones
    v = tv;
end

surf(r,X,v)
%Recover the policy function
%for b=1:n;
    
    %policy(1,b)=wp(b,I(b));
    
%end;r

%%Interpolation Code

v(1,:)=v(2,:)-10e2 ;   %makes value at 0 water a very large negative number instead of -inf


[xData, yData, zData] = prepareSurfaceData( r, X, v );

% Set up fittype and options.
ft = 'cubicinterp';
opts = fitoptions( ft );
opts.Normalize = 'on';

% Fit model to data.
[valuefit, gof] = fit( [xData, yData], zData, ft, opts );

valueint=@(w,x,r) -(u1(w,x,r)+ beta.*valuefit(r,(x + (rec + (re-1).*w.*alpha(x))./(A.*S)))) % this is the function to optimize

for i=1:n; %loops over water levels

    x=X(i);
    
    for e=1:size(r,1)  %loop over realizations of rainfall
        
[policyint(i,e) fval(i,e)]= fminsearch(@(w)valueint(w,x,r(e)),.2); % calculates optimal policy at levels

if(policyint(i)<=0);
    policyint(i)=0;
end
    end
    
    
end


%% Fit optimal policy function

[xData, yData, zData] = prepareSurfaceData( r, X, policyint );

% Set up fittype and options.
ft = 'cubicinterp';
opts = fitoptions( ft );
opts.Normalize = 'on';

% Fit model to data.
[policyopt, gof] = fit( [xData, yData], zData, ft, opts );

% Plot fit with data.
figure( 'Name', 'untitled fit 1' );
h = plot( policyopt, [xData, yData], zData );
legend( h, 'untitled fit 1', 'policyint vs. r, X', 'Location', 'NorthEast' );
% Label axes
xlabel( 'r' );
ylabel( 'X' );
zlabel( 'policyint' );
grid on
view( -45.5, 46.0 );

end



