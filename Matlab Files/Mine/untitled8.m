% computes the value of an asian option V1 and control variate V2
% S0=initial price, K=strike price
% sig = sigma, k=number of time increments in interval [0.T]
% sc is value of the score function for the normal inputs with respect to
% r the interest rate parameter. Repeats for a total of n simulations.
v1=[]; 
v2=[]; 
sc=[]; 
mn=(r-sig^2/2)*T/k;
sd=sig*sqrt(T/k); 
Y=normrnd(mn,sd,k,n);

sc= (T/k)*sum(Y-mn)/(sd^2); 
Y=cumsum([zeros(1,n); Y]);
S = S0*exp(Y); 
v1= exp(-r*T)*max(mean(S)-K,0);
v2=exp(-r*T)*max(S0*exp(mean(Y))-K,0);
disp(['standard errors ' num2str(sqrt(var(v1)/n)), num2str(sqrt(var(v1-v2)/n))])
