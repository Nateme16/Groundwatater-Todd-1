function [volume r]= conevolume(x,A)

r=( (A*43560)/pi )^(1/2)  %radius in feet for given acerage


volume=pi*(r^2)*(x/3)

end
