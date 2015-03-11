% Milstein
% with the marray!!!

tic
% sample parameters:
r = 0.05; sigma = 0.25; S0 = 100; T = 1;  n = 100; rho = 0.2; kapa = 2; theta=0.4; v=0.2;
h=(T/n);
discount = exp(-r*T);
% define h intern, as a step size in the inner loop for I21 approximation
% (= T/n/n)
hi= h^2;
  
% specify the array of m values...
marray = [100;500;1000;2500;5000;10000];

% prepare a vector for Payoffs values
VecOfPay = zeros(size(marray));
error = zeros(size(marray));
randn('state', 0);
% loop for different m values (number of paths)
for p = 1:size(marray)
  m = marray(p);
  sumpayoff = 0;

 % set seed of random number generator
  
  
  % loop for paths
   
     y1 = S0*ones(1,m); y2 = (sigma^2)*ones(1,m); S0*ones(1,m); 
     y4 = (sigma^2)*ones(1,m); y3 = S0*ones(1,m); sumy3 = S0*ones(1,m); sumy1 = S0*ones(1,m); 
     for j=1:n
     
        % inner loop for path generation (all m paths)
        zk = zeros(2,m); W3=0; W4=0;
        for k=1:n
            dW3 = randn(1,m)*sqrt(hi);
            W3 = W3 + dW3;
            dW4 = rho*dW3+ sqrt(1-rho^2)*randn(1,m)*sqrt(hi);
            W4 = W4 + dW4;
          
            % calculation of delatW as a difference between dW1(or 2) and previous dW1(or 2) in k-step                
            dW = [dW3; dW4];              
            
            % calculation of vector zk
            zk = zk + [zk(2,:).*dW(1,:);dW(2,:)];     
            
        end;
        I21 = zk(1,:);
        % I21a = -I21;
        
        dW1 = W3;
        dW2 = W4;
        dW1a = -dW1;
        dW2a = -dW2;
        y1 = y1 .* (1 + r*h + sqrt(y2).*dW1 + 0.5.*y2.*((dW1.^2) - h) + (v/2).*I21);
        y2 = y2 + kapa*(theta-y2)*h + v*sqrt(y2).*dW2 + ((v^2)/4).*((dW2.^2)-h);        
        y3 = y3 .* (1 + r*h + sqrt(y4).*dW1a + 0.5.*y4.*((dW1a.^2) - h) + (v/2).*I21);
        y4 = y4 + kapa*(theta-y4)*h + v*sqrt(y4).*dW2a + ((v^2)/4).*((dW2a.^2)-h);
        
        sumy1 = sumy1 + y1; %sum up all the values that we generated at each path
        sumy3 = sumy3 + y3; %sum up all the values that we generated at each path
              
    end;
    
    Y1 = sumy1/(n+1); %calculate the average price of the underlying for each path
    Y3 = sumy3/(n+1); %calculate the average price of the underlying for each path in the antisample
    payoff = max(y1 - Y1, 0); %calculate the payoffs for each path
    payoff2 = max(y3- Y3, 0); %calculate the payoffs for each path in the antisample
    
    % summup the payoffs of the different (m) paths
    sumpayoff = (sum(payoff) + sum(payoff2))/(2*m);
  
    
    % Calculate the average of payoffs, store in vector for each m.
  PAYOFF = discount * sumpayoff;
  VecOfPay(p) = PAYOFF;
  Xexact = 13.9698;
  error(p) = error(p) + abs(Xexact - PAYOFF);
end;

VecOfPay
error
loglog(marray,error,'*-'), hold on
loglog(marray ,(marray.^(-1)),'--'), hold off
toc

  
