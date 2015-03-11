function [CallPrice,PutPrice] = geoAsianClosed(S0,sigma,K,r,T,steps)
Nt = T/steps;

sigsqT= sigma^2*T*(2*Nt+1)/(6*Nt+6); 
muT = 0.5*sigsqT + 0.5*(r - 0.5*sigma^2)*T; 

d1=(log(S0/K) + (muT + 0.5*sigsqT))/(sqrt(sigsqT)); 
d2=d1 - sqrt(sigsqT); 

CallPrice = exp(-r*T)*(S0*exp(muT)*normcdf(d1)-K*normcdf(d2));
PutPrice = exp(-r*T)*(K*normcdf(-d2)-S0*exp(muT)*normcdf(-d1));
end