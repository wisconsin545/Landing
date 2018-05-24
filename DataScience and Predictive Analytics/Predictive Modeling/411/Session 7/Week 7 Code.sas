/* Read in the data set */
Data steel;
input isweights @@;
RETAIN YEAR 1936;
YEAR+1;
CARDS;
3.89 2.41 2.8 8.72 7.12 7.24 7.15 6.05 5.21 5.03 6.88 4.7 5.06 3.16
3.62 4.55 2.43 3.16 4.55 5.17 6.95 3.46 2.13 3.47 2.79 2.52 2.8 4.04
3.08 2.28 2.17 2.78 5.94 8.14 3.55 3.61 5.06 7.13 4.15 3.86 3.22
3.5 3.76 5.11
;

data steel;
	set steel;
	ln_s=log(isweights);
	run;
	

*****Initial Desriptive Statistics*****;
proc univariate data=steel;
	var isweights Ln_S;
	histogram / normal; 
run;


* Produce LOESS scatterplot;
ods graphics on;
proc sgscatter data=steel;
compare x=(year)
		y=isweights / loess; 
run; quit;
ods graphics off;

* Produce LOESS scatterplot for log;
ods graphics on;
proc sgscatter data=steel;
compare x=(year)
		y=ln_s / loess; 
run; quit;
ods graphics off;

proc sgplot data=steel;
SCATTER y=isweights x=year;
REG y=isweights x=year / CLM;
LOESS y=isweights x=year;
run;

proc sgplot data=steel;
SCATTER y=ln_s x=year;
REG y=ln_s x=year / CLM;
LOESS y=ln_s x=year;
run;




PROC SGPLOT DATA=STEEL;
SERIES x=YEAR y=isweights;
RUN;




*****First Iteration*****;
PROC ARIMA data=steel;
IDENTIFY var=isweights SCAN ESACF MINIC STATIONARITY=(RANDOMWALK) NLAG=10;
Run;
ESTIMATE P=1 PLOT GRID;
OUTLIER ID=YEAR;
run;

PROC ARIMA data=steel;
IDENTIFY var=ln_s SCAN ESACF MINIC STATIONARITY=(RANDOMWALK) NLAG=10;
Run;
ESTIMATE P=1 PLOT GRID;
OUTLIER ID=YEAR;
run;

*****Second Iteration Bingo - First Assumption Met*****; 
PROC ARIMA data=steel;
IDENTIFY var=isweights (1) SCAN ESACF MINIC STATIONARITY=(RANDOMWALK) NLAG=10;
Run;
ESTIMATE P=1 PLOT GRID;
OUTLIER ID=YEAR;
run;

*****Plotting the Second difference*****;
PROC ARIMA data=steel;
IDENTIFY var=isweights (2) SCAN ESACF MINIC STATIONARITY=(RANDOMWALK) NLAG=10;
Run;
ESTIMATE P=1 PLOT GRID;
OUTLIER ID=YEAR;
run;

*****Fitting the Model*****;
PROC ARIMA data=steel;
IDENTIFY var=isweights(1) NLAG=10 NOPRINT;
ESTIMATE P=1 q=2 PLOT GRID;
OUTLIER ID=YEAR;
Run;


PROC ARIMA data=steel;
IDENTIFY var=isweights(1) SCAN ESACF MINIC STATIONARITY=(DICKEY) NLAG=10;
Run;
ESTIMATE Q=2 PLOT GRID;
OUTLIER ID=YEAR;
FORECAST lead=5 out=results;
run;
QUIT;

*****Basic Stuff*****; 
proc contents data=steel;
run;
proc print data=steel (obs=20);
run;

*****Fitting the Model (Basic Assessment)*****;
title "Iron and Steel Exports Excluding Scraps";
title2 "Weight in Million Tons";
title3 "1937 -1980";
proc arima data=steel;
	identify var=isweights (1) nlag=10;
run;

*****This is the AR Model*****;
PROC ARIMA data=steel;
IDENTIFY var=isweights (1) SCAN ESACF MINIC STATIONARITY=(RANDOMWALK) NLAG=10;
Run;
ESTIMATE P=1 PLOT GRID;
OUTLIER ID=YEAR;
FORECAST lead=5 out=results;
run;

*****With the Dickey Statement*****;
*****This is the AR Model*****;
PROC ARIMA data=steel;
IDENTIFY var=isweights (1) SCAN ESACF MINIC STATIONARITY=(dickey) NLAG=10;
Run;
ESTIMATE P=1 PLOT GRID;
OUTLIER ID=YEAR;
FORECAST lead=5 out=results;
run;

*****This is the MA Model*****;
PROC ARIMA data=steel;
IDENTIFY var=isweights(1) SCAN ESACF MINIC STATIONARITY=(DICKEY) NLAG=10;
Run;
ESTIMATE Q=2 PLOT GRID;
OUTLIER ID=YEAR;
FORECAST lead=5 out=results;
run;
QUIT;

*****This is the ARMA model*****;
PROC ARIMA data=steel;
IDENTIFY var=isweights(1) NLAG=10;
ESTIMATE P=1 q=2 PLOT GRID;
OUTLIER ID=YEAR;
Run;