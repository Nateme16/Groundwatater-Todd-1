
%-------------------------------------------------
%   CODE TO GENERATE FIGURES IN 
%   HSIANG (2012): "VISUALLY-WEIGHTED REGRESSION"
%   (RUNS IN MATLAB)
%-------------------------------------------------

%-------------------------------------------------
%   REQUIRES:
%
%               VWREGRESS.M
%
%   AND RELATED SUBFUNCTIONS:
%
%               DROP_MISSING_Y.m  
%               PLOT_COLORED_LINE.m
%
%   WHICH ARE AVAILABLE AT 
%   www.solomonhsiang.com/computing/data-visualization.
%-------------------------------------------------

clear
N = 100;

%------------------------FIGURE 1
figure(1)
clf

% FUNCTION THAT WE ARE TRYING TO RECOVER
X_bins = -4:.1:4;
y_true = 1+ 6*X_bins + 2*X_bins.^2 - X_bins.^3;
plot(X_bins, y_true,'k')
box off
hold on
axis([-3     3   -15    20])
xlabel('X'); 
ylabel('Y'); 
title(['Underlying function and observations (N = ' num2str(N) ')']);


% STOCHASTIC DATA GENERATING PROCESS
x = 1.2*randn([N,1]);
error = 1.5*(1+x.^2).*randn([N,1]);
y = 1+ 6*x + 2*x.^2 - x.^3 + error;
plot(x,y,'ko');

%------------------------FIGURE 2

% PANEL WITH CONFIDENCE INTERVALS AND HISTOGRAM
figure(2)
clf
vwregress(x,y,30,1,1000,'SOLID','HIST');
axis([-3     3   -10    15])

% PANEL WITH ONLY VISUALLY WEIGHTED REGRESSION
figure(3)
clf
vwregress(x,y,30,1);
axis([-3     3   -10    15])
xlabel('X'); 
ylabel('Y');
title('Visually-weighted regression')


%------------------------FIGURE 4

% FUNCTION THAT WE ARE TRYING TO RECOVER
X_bins = -5:.1:5;

y_true1 = 1+ 6*X_bins + 2*X_bins.^2 - X_bins.^3;
y_true2 = 1+ 6*X_bins + 3*X_bins.^2;
y_true3 = 1+ 6*X_bins + X_bins.^2 - 2*X_bins.^3;
y_true4 = 1+ 6*X_bins - 3*X_bins.^3;

figure(4)
clf
subplot(1,2,1)
box off
hold on

plot(X_bins, y_true1,'k')
plot(X_bins, y_true2,'Color',[0 0 1])
plot(X_bins, y_true3,'Color',[0 1 0])
plot(X_bins, y_true4,'Color',[1 0 0])

% STOCHASTIC DATA GENERATING PROCESS
N = 100;

x1 = 1.2*randn([N,1]);
error = 1.5*(1+x1.^2).*randn([N,1]);
y1 = 1+ 6*x1 + 2*x1.^2 - x1.^3 + error;

x2 = 1.2*randn([N,1]);
error = 1.5*(1+x2.^2).*randn([N,1]);
y2 = 1+ 6*x2 + 3*x2.^2  + error;

x3 = 1.2*randn([N,1]);
error = 1.5*(1+x3.^2).*randn([N,1]);
y3 = 1+ 6*x3 + x3.^2 - 2*x3.^3 + error;

x4 = 1.2*randn([N,1]);
error = 1.5*(1+x4.^2).*randn([N,1]);
y4 = 1+ 6*x4 - 3* x4.^3 + error;

plot(x1,y1,'ko');
plot(x2,y2,'o', 'Color',[0 0 1]);
plot(x3,y3,'o', 'Color',[0 1 0]);
plot(x4,y4,'o', 'Color',[1 0 0]);

%PANEL WIH VISUALLY WEIGHTED REGRESSIONS

title(['Underlying functions and observations (N = ' num2str(N) ' in each sample)']); 
xlabel('X')
ylabel('Y')

subplot(1,2,2)
box off
hold on

vwregress(x1,y1,30,1);
vwregress(x2,y2,30,1, [0 0 1]);
vwregress(x3,y3,30,1, [0 1 0]);
vwregress(x4,y4,30,1, [1 0 0]);

linkaxes

title(['Visually-weighted regressions']); 
xlabel('X')
ylabel('Y')

%------------------------FIGURE 5

figure(5)
clf
subplot(2,2,1)
vwregress(x4,y4,30,1,100,'SOLID',[1 0 0]);
vwregress(x2,y2,30,1,100,'SOLID',[0 0 1]);
title('95% CI, no visual weighting')
subplot(2,2,2)
vwregress(x4,y4,30,1,100,[1 0 0]);
vwregress(x2,y2,30,1,100,[0 0 1]);
title('95% CI, visual weighting by sqrt(N)')
subplot(2,2,3)
vwregress(x4,y4,30,1,100,'CI',[1 0 0]);
vwregress(x2,y2,30,1,100,'CI',[0 0 1]);
title('95% CI, visual weighting by -abs(CI)')
subplot(2,2,4)
vwregress(x4,y4,30,1,'CI',[1 0 0]);
vwregress(x2,y2,30,1,'CI',[0 0 1]);
title('visual weighting by -abs(CI)')
linkaxes
