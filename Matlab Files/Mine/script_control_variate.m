% Script to price an Asian option using a monte-carlo approach.
% Using geometric average Asian option as a control variate

%--------------------------------------------------------------------------
clc;
clear all;

S0 =100;       % Price of underlying today
K = 90;       % Strike at expiry
sigma = 0.2;  % expected vol.
r = 0.05;      % Risk free rate
T = 1; 
steps = 500;
nruns = 100000; % Number of simulated paths

fprintf('Monte Carlo computation of Asian Option price: \n\n');
parameters = {'Parameters','Values';'S0',S0 ;'K',K;...
    'sigma',sigma;'r',r;'T',T;'steps',steps;'nruns',nruns;};
disp(parameters);
display('----------------------------------------------------------------')

%--------------------------------------------------------------------------
% Generate potential future asset paths
S = AssetPaths(S0,r,sigma,T,steps,nruns);
%plot(S);

%--------------------------------------------------------------------------
% Arithmetic average:
% calculate the payoff for each path for a Put: 
aPutPayoff = max(K-mean(S),0);

% calculate the payoff for each path for a Call:
aCallPayoff = max(mean(S)-K,0);

% discount back
aPutPrice = mean(aPutPayoff)*exp(-r*T);
aCallPrice = mean(aCallPayoff)*exp(-r*T);
%--------------------------------------------------------------------------
% Geometric average:
% Calculate exact asian option price using geometric average
[g_price_call_real, g_price_put_real] = geoAsianOpt(S0,sigma,K,r,T,steps);

% Calculate Monte Carlo geometric price
gPutPayoff = max(K-geomean(S),0);
gCallPayoff = max(geomean(S)-K,0);

% Discount back
gPutPrice = mean(gPutPayoff)*exp(-r*T);
gCallPrice = mean(gCallPayoff)*exp(-r*T);

%--------------------------------------------------------------------------
% Control variate optimal coefficient:

cov_geometric_call = cov(gCallPayoff,aCallPayoff);
k_opt_call = -cov_geometric_call(1,2)/cov_geometric_call(2,2);

cov_geometric_put = cov(gPutPayoff,aPutPayoff);
k_opt_put = -cov_geometric_put(1,2)/cov_geometric_put(2,2);

%--------------------------------------------------------------------------
% Calculate the control variate (with geometric average) estimate:
% Put:

PutPrice = aPutPrice + k_opt_put(1,2)*(gPutPrice - g_price_put_real);
VarPutPrice = var(aPutPayoff)...
                        - cov(gPutPayoff,aPutPayoff)^2/var(gPutPayoff);

% Call:
CallPrice = aCallPrice + k_opt_call(1,2)*(gCallPrice - g_price_call_real);
VarCallPrice = var(aCallPayoff)...
                        - cov(gCallPayoff,aCallPayoff)^2/var(gCallPayoff);
                                       
%--------------------------------------------------------------------------
%Display:
fprintf('Results: \n');

fprintf('\n Asian option value computed without control variable: \n')
output = {'Type','Price','Variance';...
    'Put',aPutPrice,var(aPutPayoff);...
    'Call',aCallPrice,var(aCallPayoff);};
disp(output);

fprintf('\n Asian option value computed with control variable: \n');
output = {'Type','Price','Variance';...
    'Put',PutPrice,VarPutPrice(1,2);...
    'Call',CallPrice,VarCallPrice(1,2);};
disp(output);

fprintf('\n Asian option value computed with geometric average: \n');
output = {'Type','MC Price','MC Variance','Real Price';...
    'Put',gPutPrice,var(gPutPayoff),g_price_put_real;...
    'Call',gCallPrice,var(gCallPayoff),g_price_call_real;};
disp(output);

