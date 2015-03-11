% Script to price an Put and Callon an Asian option using
% the Monte-Carlo approach with the control variate variance
% reduction technique

% Define the underlying parameters
S0 =100;
X = 90;
r = 0.15;
sig = 0.30;
dt = 1/1000;
etime = 1000; % days to expiry
T = dt*etime;

nruns = 100000;

% Calculate the Black-Scholes price for the European Call and Put
% This assumes that the Financial Toolbox is available
[blsEC,blsEP] = blsprice(S0,X,r,T,sig)

% Price the above vanilla Put and Call using Monte-Carlo
% The European option is not path dependent so only one step is required
S = AssetPaths(S0,r,sig,T,1,nruns);
Sf = S(end,:);  % The simulated prices at expiry
% Calculate the Monte-Carlo European Put and Call prices
mcEC = mean(max(Sf-X,0))*exp(-r*T)
mcEP = mean(max(X-Sf,0))*exp(-r*T)

% Calculate an initial price for the Asian option using Monte-Carlo
S = AssetPaths(S0,r,sig,dt,etime,nruns);
% calculate the payoff for each path for a Put
PutPayoffT = max(X-mean(S),0);
% calculate the payoff for each path for a Call
CallPayoffT = max(mean(S)-X,0);
% discount back
putPrice0 = mean(PutPayoffT)*exp(-r*T)
callPrice0 = mean(CallPayoffT)*exp(-r*T)

% Use the basic control variates approach to calculate a final price
putPrice = putPrice0 + (blsEP - mcEP)
callPrice = callPrice0 + (blsEC - mcEC)  