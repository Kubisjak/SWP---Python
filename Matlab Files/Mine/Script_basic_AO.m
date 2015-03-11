% Script to price an Asian option using a monte-carlo approach.

S0 =100;       % Price of underlying today
K = 110;       % Strike at expiry
sigma = 0.30;    % expected vol.
r = 0.15;     % Risk free rate
T = 1; 
steps = 1000;
nruns = 100000; % Number of simulated paths


% Generate potential future asset paths
S = AssetPaths(S0,r,sigma,T,steps,nruns);
%plot(S);

% calculate the payoff for each path for a Put
PutPayoffT = max(K-mean(S),0);

% calculate the payoff for each path for a Call
CallPayoffT = max(mean(S)-K,0);

% discount back
putPrice = mean(PutPayoffT)*exp(-r*T)
callPrice = mean(CallPayoffT)*exp(-r*T)

