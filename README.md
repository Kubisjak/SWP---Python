Asian option pricing GUI Interface
	- 01SWP Summer 2015 proposal

**Aim:** 
Calculate the price of Asian options using Monte Carlo and/or differential equations solver and create corresponding GUI in Python in order to present the results of pricing in the Master Thesis. Python chosen instead of Matlab as suitable free alternative.

**Current State:** 

1. Previous developed Matlab working scripts and functions available. 

2. 1/5 of content already transferred to Python

**SWP GUI Focus:**
Create suitable GUI that accomodates calculations of developed Monte Carlo scripts and displays pricing results in a concise way. 

The developed GUI should:

1.  Let the user input desired parameters to calculate options.
This could be achieved by input fields for each parameters.

2.  Let the user choose selected underlying process. 
Possible to do by selecting dropdown menu. The input fields of parameters will differ after selecting a process.

3. Let the user decide whether or not to run additional variance reduction algorithms in the Monte Carlo. 
Tick box.

4. Present graph of underlying process with highlighted average and option price difference. 

5. Output all results of calculations in a table or appealing/presentable way.

6. Export results button.

**Possible (future) upgrades:**

1. Option to integrate Matlab code with Python. Usable when the rewrite proves too difficult.

2. Adding constantly updating interest rate forecast graph in order to calculate the parameters of stochastic interest rates

3. Adding various summaries from the stock market to see current prices of options trading. 
