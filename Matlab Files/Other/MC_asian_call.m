%Basic Monte Carlo Asian Option pricing
%Jakub Kubis 28.7.2014

S0 = 100;
K = 105;
sigma = 0.05;
T = 1;
r = 0.15;

n_sims = 100000;
steps = 256;
dt = T/steps;

%Simulation of n Brownian paths
z = randn(nsim,steps);
w = sqrt(dt)*cumsum(z,2);
w = [zeros(nsim,1),w];


% z = randn(n_sims,1);
% S = S0*exp(sigma*sqrt(T)*z + (r-sigma^2/2)*T);
% C = max(0,S-K);
% call = exp(-r*T)*sum(C)/n_sims;