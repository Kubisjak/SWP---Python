% Script to price an Asian option using a monte-carlo approach.
% Using European Option as a control variate

%--------------------------------------------------------------------------
clc;

S0 =100;       % Price of underlying today
K = 110;       % Strike at expiry
sigma = 0.2;  % expected vol.
r = 0.05;      % Risk free rate
T = 1; 
steps = 500;
nruns = 10000; % Number of simulated paths

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
% European option:
% Exact price using Black-Scholes model:
[blsEuroCallPrice,blsEuroPutPrice] = blsprice(S0,K,r,T,sigma);

% Only one step si required for European option
S = AssetPaths(S0,r,sigma,T,1,nruns);

Sf = S(end,:);  % The simulated prices at expiry

% Calculate the Monte-Carlo European Put and Call prices
mcEuroCallPayoff = max(Sf-K,0);
mcEuroPutPayoff = max(K-Sf,0);

mcEuroCallPrice = mean(mcEuroCallPayoff)*exp(-r*T);
mcEuroPutPrice = mean(mcEuroPutPayoff)*exp(-r*T);

%--------------------------------------------------------------------------
% Control variate optimal coefficient:
cov_Euro_call = cov(mcEuroCallPayoff,aCallPayoff);
k_opt_call = -cov_Euro_call(1,2)/cov_Euro_call(2,2);

cov_Euro_put = cov(mcEuroPutPayoff,aPutPayoff);
k_opt_put = -cov_Euro_put(1,2)/cov_Euro_put(2,2);



%--------------------------------------------------------------------------
% Calculate the control variate (with European option) estimate:
% Put:

PutPrice = aPutPrice + k_opt_put*(mcEuroPutPrice - blsEuroPutPrice);

VarPutPrice = var(aPutPayoff)...
                        - cov(mcEuroPutPayoff,aPutPayoff)^2 ...
                        /var(mcEuroPutPayoff);

% Call:
CallPrice = aCallPrice + k_opt_call*(mcEuroCallPrice - blsEuroCallPrice);

VarCallPrice = var(aCallPayoff)...
                        - cov(mcEuroCallPayoff,aCallPayoff)^2 ... 
                        /var(mcEuroCallPayoff);
                                       
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

fprintf('\n European option value: \n');
output = {'Type','MC Price','MC Variance','Real Price';...
    'Put',mcEuroPutPrice,var(mcEuroPutPayoff),blsEuroPutPrice;...
    'Call',mcEuroCallPrice,var(mcEuroCallPayoff),blsEuroCallPrice;};
disp(output);

