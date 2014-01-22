
%% Iteration 

%Finds optimal value function for parameters in findpolicy.m at n accuracy
n=1000
[optimalchoice]=findpolicy(n)

j=1000
xstart=800
x=[xstart:1:1000]
r=.5

for i=1:j
  
    
    
    
    
     
    
    x(i+1)= x(i) + r - (1-re)*w / (A*S)
end

