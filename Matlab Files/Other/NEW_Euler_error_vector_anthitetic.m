% Euler-Maruyama

% sample parameters:
r = 0.05; sigma = 0.25; S0 = 100; T = 1;  n = 100; rho = 0.2; kapa = 2; theta=0.4; v=0.2;
h=(T/n);

tic  

marray = [1000000;100000;10000;1000;100;10]; % specify the array of m values.
discount = exp(-r*T);
VecOfPay = zeros(size(marray)); %create an array for values of the option for different 'm' sizes
error = zeros(size(marray));% create an array for the errors
randn('state', 0); % use new generation control for random numbers

for p = 1:size(marray) %outer loop for different 'm' values
    m = marray(p);
    sumpayoff = 0;
    
    %use vectors at each point in time and handle all paths at the same time
    y1 = S0*ones(1,m); y2 = (sigma^2)*ones(1,m); S0*ones(1,m); 
    y4 = (sigma^2)*ones(1,m); y3 = S0*ones(1,m); sumy3 = S0*ones(1,m); sumy1 = S0*ones(1,m); 
    
    for j=1:n %inner loop for path generation (all m paths)
        dW1 = randn(1,m)*sqrt(h);
        dW2 = rho*dW1 + sqrt(1-rho^2)*randn(1,m)*sqrt(h);
        
        y2 = y2 + kapa*(theta-y2)*h + v*sqrt(y2).*dW2; %sample for volatility
        y1 = y1 .* (1 + r*h + sqrt(y2).*dW1); %sample for the underlying price
        y4 = y4 + kapa*(theta-y4)*h + v*sqrt(y4).*-dW2;%antisample for volatility
        y3 = y3 .* (1 + r*h + sqrt(y4).*-dW1);%antisample for the underlying price
        
        sumy1 = sumy1 + y1; %sum up all the values that we generated at each path
        sumy3 = sumy3 + y3; %sum up all the values that we generated at each path
              
    end;
    
    Y1 = sumy1/(n+1); %calculate the average price of the underlying for each path
    Y3 = sumy3/(n+1); %calculate the average price of the underlying for each path in the antisample
    
    payoff = max(y1 - Y1, 0); %calculate the payoffs for each path
    payoff2 = max(y3- Y3, 0); %calculate the payoffs for each path in the antisample
    
    sumpayoff = (sum(payoff) + sum(payoff2))/(2*m); %calculate the average payoff of the option 
    PAYOFF = discount * sumpayoff; %discount payoffs
    VecOfPay(p) = PAYOFF; %add it to the respective field of our vector 
    %we don't have an exact closed form solution, so take the value of m=
    %50,000,000 as exact value
    Xexact = 14.7110; 
    error(p) = error(p) + abs(Xexact - PAYOFF); % calculate errors

end;

VecOfPay
error

loglog(marray,error,'*-'), hold on %plot the errors
loglog(marray ,(marray.^(-0.5)),'--'), hold off
xlabel('Number of simulations (m)')
ylabel('Error size')
toc
  