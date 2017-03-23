function [P meanp]=raintime(j,prob,r)
    
%j=100000  ; %nubmer of years;

rntest(1)=randsample(r,1,true);

for i=1:j;% creates j length rainfall time series
    ind=randp(prob(:,find(r==rntest(i)))',1,1);
    rntest(i+1)=r(ind)  ;
end


P=histc(rntest,r)./size(rntest,2)

meanp=mean(rntest)
end