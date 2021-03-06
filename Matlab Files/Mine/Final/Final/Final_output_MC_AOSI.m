clear all;
clc;

Param_nruns = [100,200,500,1000,10000];
Param_sigmaS = [0.05, 0.1, 0.2, 0.3];
Param_K = [90, 100, 110];



%--------------------------------------------------------------------------
% Set up parameters for Asian Options:
S0 =100;       % Price of underlying today
K = 90;       % Strike at expiry
sigmaS = 0.05;  % expected vol.
T = 1; 
nsteps = 500;
nsims = 10000; % Number of simulated paths

% Set up parameters for UO model in stochastic interest rate:
R0 = 0.15; %initial value
sigmaR = 0.05; % volatility
gamma = 0.15; %long term mean
alpha = 2; % rate of mean reversion

rho = 0.5;
dt=T/nsteps;


file = fopen('MC_AOSI_output.tex', 'w');
fprintf(file, '\\begin{tabular}{|rrrrrr|}\\hline \n');
fprintf(file, '$\\sigma_s$ & $K$ & MC Price & Variance & STD Error & \\shortstack[r]{ Constant interest \\\\ Ve\\v{c}e\\v{r}''s price} \\\\ \\hline \\hline \n');

for i=1:length(Param_sigmaS)
        fprintf(file, '%8.2f',Param_sigmaS(i));
for j=1:length(Param_K)
    
[price_call,price_put] = Vecer_asiancontinuous(S0,Param_K(j),gamma,Param_sigmaS(i),T);
    
%--------------------------------------------------------------------------
[SR,R] = simAssetPathsWithInterests(S0,Param_sigmaS(i),T,R0,gamma,alpha,sigmaR,nsteps,nsims,rho);
%--------------------------------------------------------------------------
% Arithmetic average:
% calculate the payoff for each path for a Call:

AssetPathsMean = mean(SR,2);
Rdt = R.*dt ;
DiscountR =  sum(Rdt,2);

aCallPayoff = max(AssetPathsMean-Param_K(j),0); % MEAN OF ROWNS !!!!

aCallPrice = aCallPayoff.*exp(-DiscountR); %Each row is discounted with mean of corresponding interest rate process

aCallPrice_mean = mean(aCallPrice);
aCallPrice_STDerror = std(aCallPrice)/sqrt(nsims);
%--------------------------------------------------------------------------
% Output:

    fprintf(file, '    & %8.0f & %8.2f & %8.2f & %8.4f & %8.2f \\\\ ',Param_K(j),aCallPrice_mean, var(aCallPrice),aCallPrice_STDerror,price_call);
    fprintf(file, '\n');
    
    if j==length(Param_K) 
        if i~=length(Param_sigmaS)
        fprintf(file, '\\hline \\hline ');
        else fprintf(file, '\\hline');
        end
    end

end
end

fprintf(file, '\\end{tabular}\n');
fclose(file);
movefile('MC_AOSI_output.tex','/Users/Kubisjak/Google Drive/Vyzkumak/Vypracovanie/Final/Matlab');
