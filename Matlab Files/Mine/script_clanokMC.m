clear all;
clc;

S0 =100;       % Price of underlying today
K = 100;       % Strike at expiry
sigma = 0.2;  % expected vol.
r = 0.05;      % Risk free rate
T = 1; 
steps = 500;
nruns = 10000; % Number of simulated paths


%--------------------------------------------------------------------------
% Generate potential future asset paths
S = AssetPaths(S0,r,sigma,T,steps,nruns);

%--------------------------------------------------------------------------
% Arithmetic average:
% calculate the payoff for each path for a Put: 
aPutPayoff = max(K-mean(S),0);

% calculate the payoff for each path for a Call:
aCallPayoff = max(mean(S)-K,0);

% discount back
aPutPrice = aPutPayoff*exp(-r*T);
aCallPrice = aCallPayoff*exp(-r*T);

aPutPrice_mean = mean(aPutPrice);
aCallPrice_mean = mean(aCallPrice);

aPutPrice_STDerror = std(aPutPrice)/sqrt(nruns);
aCallPrice_STDerror = std(aPutPrice)/sqrt(nruns);

% fprintf('Basic Monte Carlo Asian option valuation: \n');
% 
% fprintf('\n Put price:  %f\n',aPutPrice_mean)
% fprintf(' Standard error:  %f\n',aPutPrice_STDerror)
% fprintf(' Variance: %f\n',var(aPutPrice))
% 
% fprintf('\n Call price: %f\n',aCallPrice_mean)
% fprintf(' Standard error:  %f\n',aCallPrice_STDerror)
% fprintf(' Variance: %f\n',var(aCallPrice))

%--------------------------------------------------------------------------
%Geometric average:
% Calculate exact asian option price using geometric average
[gCallPriceReal, gPutPriceReal] = geoAsianOpt(S0,sigma,K,r,T,steps);

% Calculate Monte Carlo geometric price
gPutPayoff = max(K-geomean(S),0);
gCallPayoff = max(geomean(S)-K,0);

% Discount back
gPutPrice = gPutPayoff*exp(-r*T);
gCallPrice = gCallPayoff*exp(-r*T);

gPutPrice_mean = mean(gPutPrice);
gCallPrice_mean = mean(gCallPrice);

gPutPrice_STDerror = std(gPutPrice)/sqrt(nruns);
gCallPrice_STDerror = std(gPutPrice)/sqrt(nruns);

% fprintf('\nMonte Carlo valuation of Asian option with geometric mean: \n');
% 
% fprintf('\n Put price:  %f\n',gPutPrice_mean)
% fprintf(' Standard error:  %f\n',gPutPrice_STDerror)
% fprintf(' Accurate value: %f\n',gPutPriceReal)
% fprintf(' Variance: %f\n',var(gPutPrice))
% 
% fprintf('\n Call price: %f\n',gCallPrice_mean)
% fprintf(' Standard error:  %f\n',gCallPrice_STDerror)
% fprintf(' Accurate value: %f\n',gCallPriceReal)
% fprintf(' Variance: %f\n',var(gCallPrice))

%--------------------------------------------------------------------------
%Control variate coefficient:

cov_geometric_call = cov(gCallPayoff,aCallPayoff);
k_opt_call = -cov_geometric_call(1,2)/cov_geometric_call(2,2);

cov_geometric_put = cov(gPutPayoff,aPutPayoff);
k_opt_put = -cov_geometric_put(1,2)/cov_geometric_put(2,2);

%--------------------------------------------------------------------------
% Calculate the control variate (with geometric average) estimate:

% Put:
PutPrice = aPutPrice + k_opt_put*(gPutPrice - gPutPriceReal);
PutPrice_mean = mean(PutPrice);
%VarPutPrice = var(aPutPayoff) - cov(gPutPayoff,aPutPayoff)^2/var(gPutPayoff);
PutPrice_STDerror = std(PutPrice)/sqrt(nruns);

% Call:
CallPrice = aCallPrice + k_opt_call*(gCallPrice - gCallPriceReal);
CallPrice_mean = mean(CallPrice);
%VarCallPrice = var(aCallPayoff) - cov(gCallPayoff,aCallPayoff)^2/var(gCallPayoff);
CallPrice_STDerror = std(CallPrice)/sqrt(nruns);


%--------------------------------------------------------------------------
% Output:

% fprintf('\nMonte Carlo valuation of Asian option with control variate: \n');
% 
% fprintf('\n Put price:  %f\n',PutPrice_mean)
% fprintf(' Standard error:  %f\n',PutPrice_STDerror)
% fprintf(' Variance: %f\n',var(PutPrice))
% 
% fprintf('\n Call price: %f\n',CallPrice_mean)
% fprintf(' Standard error:  %f\n',CallPrice_STDerror)
% fprintf(' Variance: %f\n',var(CallPrice))

fprintf('Summary: \n\n');

put = {'Estimation','Basic','Geometric','Control Variate';...
    'Put price: ',aPutPrice_mean,gPutPrice_mean,PutPrice_mean; ...
    'Standard error: ',aPutPrice_STDerror,gPutPrice_STDerror,PutPrice_STDerror; ...
    'Variance: ',var(aPutPrice),var(gPutPrice),var(PutPrice)};

call = {'Estimation','Basic','Geometric','Control Variate';...
    'Call price: ',aCallPrice_mean,gCallPrice_mean,CallPrice_mean; ...
    'Standard error: ',aCallPrice_STDerror,gCallPrice_STDerror,CallPrice_STDerror; ...
    'Variance: ',var(aCallPrice),var(gCallPrice),var(CallPrice)};

disp(call);
disp(put);

