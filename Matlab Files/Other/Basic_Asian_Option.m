% Script to price an Asian option using a monte-carlo approach.

S0 =100;       % Price of underlying today
X = 100;       % Strike at expiry
%mu = 0.04;    % expected return
sig = 0.30;    % expected vol.
r = 0.15;     % Risk free rate
dt = 1/1000;   % time steps
etime = 1000;   % days to expiry
T = dt*etime; % years to expiry

nruns = 1000; % Number of simulated paths

% Generate potential future asset paths
S = AssetPaths(S0,r,sig,dt,etime,nruns);

% calculate the payoff for each path for a Put
PutPayoffT = max(X-mean(S),0);

% calculate the payoff for each path for a Call
CallPayoffT = max(mean(S)-X,0);

% discount back
putPrice = mean(PutPayoffT)*exp(-r*T)
callPrice = mean(CallPayoffT)*exp(-r*T)