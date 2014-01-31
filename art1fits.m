
function [prob] = ar1trans(rain_yearlyinches)

%load('/Users/nateme16/Documents/MATLAB/Groundwatater Todd 1/ar1start.mat')
for i=1:size(rain_yearlyinches);
rn=rain_yearlyinches(i);

RN(:,i)=  4.701501+.4102023*rn + err;
RNR(:,i)=roundtowardvec(RN(:,i),rain_yearlyinches,'round');

prob_y = arrayfun(@(x)length(find(RNR(:,i)==x)), unique(RNR(:,i))) / length(RNR(:,i));

lookup=[ unique(unique(RNR(:,i))),prob_y];

for n=1:size(rain_yearlyinches,1);
   
   [m,j]= find(abs(lookup(:,1)-rain_yearlyinches(n))<.00001,1);
 
   if(size(m,1)==0);
      prob(n,i)=0;
   else
   prob(n,i)=lookup(m,2);
   end
 
end
end

end
