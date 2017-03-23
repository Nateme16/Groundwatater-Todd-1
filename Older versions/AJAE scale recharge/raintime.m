%% raintime
% calculate non-conditional probabilities to the MC process rainfall
% realizations. Also returns the average of the process.
% 
% inputs:
% j - length of timeseries 
% prob - Stochastic MC transition probabilities
% r - possible rainfall states

function [P meanp]=raintime(j,prob,r)
    
rns(1)=randsample(r,1,true);

for i=1:j;% creates j length rainfall time series
    ind=randp(prob(:,find(r==rns(i)))',1,1); % draws based on prob 
    rns(i+1)=r(ind)  ; %daws i+1 rainfall based on conditional probabilities
end

P=histc(rns,r)./size(rns,2) %calcuates non-conditional probabilities for stochastic scenario
meanp=mean(rns) % average for deterministic scenario
end