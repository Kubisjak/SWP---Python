%Control Variate: geometric average asian option
function V = AO_geometric_average(r,T,steps,)
V = exp(-r*T)*max(0,exp(1/(m+1)*sum(log(S)))-K);
