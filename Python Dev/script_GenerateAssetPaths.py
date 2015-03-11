# -*- coding: utf-8 -*-
"""
Created on Wed Mar 11 14:17:18 2015

@author: Kubisjak

Function will simulate Asset Paths with Stochastic Interest


def SimAssetPaths(S0,sigmaS,T,R0,gamma,alpha,sigmaR,nsteps,nsims,rho):
    
    return AssetPaths, AssetPathsWithInterest
"""
from __future__ import division # Force float division
import math
import numpy as np
import matplotlib.pyplot as plt

# Set up parameters for Asian Options:
S0 =100;       # Price of underlying today
K = 90;       # Strike at expiry
sigmaS = 0.05;  # expected vol.
T = 1; 
nsteps = 100;
nsims = 15; # Number of simulated paths

# Set up parameters for UO model in stochastic interest rate:
R0 = 0.15; #initial value
sigmaR = 0.05; # volatility
gamma = 0.15; #long term mean
alpha = 2; # rate of mean reversion

rho = 0.5;
dt=T/nsteps;


AssetPaths = np.zeros((nsims,nsteps+1))
InterestPaths = np.zeros((nsims,nsteps+1))

AssetPaths[:,0] = S0
InterestPaths[:,0] = R0

W1 = np.random.randn(nsims,nsteps)
W2 = rho*W1 + np.sqrt(1-rho**2)*np.random.randn(nsims,nsteps);

dt = T/nsteps;

sigmaRdt = sigmaS*np.sqrt(dt);

gammadt = gamma*(1-np.exp(-alpha*dt));


for i in range(0,nsims):
    for j in range(0,nsteps):
        
        InterestPaths[i,j+1] = InterestPaths[i,j] * np.exp(-alpha*dt) + gammadt + sigmaR * np.sqrt((1-np.exp(-2*alpha*dt)) / (2*alpha)) * W1[i,j]
            
        AssetPaths[i,j+1]=AssetPaths[i,j]*np.exp((InterestPaths[i,j]-0.5*sigmaS**2)*dt + sigmaRdt*W2[i,j]);

plt.plot(AssetPaths.T)
