% Simulation of Wiener process/Brownian path
N = 1000; % number of timesteps
randn('state',0); % initialize random number generator
T = 1; % final time
dt = T/(N-1); % time step
t = 0:dt:T;
dW = sqrt(dt)*randn(1,N-1); % Wiener increments
W = [0 cumsum(dW)]; %Brownian path

plot(W);