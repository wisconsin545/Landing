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
	ln_steel=log(steel);
	run;
	
*****Initial Desriptive Statistics*****;
proc univariate data=steel;
	var isweights Ln_S;
	histogram / normal; 
run;

data steel;
	set mydata56.steel_exp_week_6;
	run;

proc print data=steel;


* Produce LOESS scatterplot smoothers in panels of three;
ods graphics on;
proc sgscatter data=steel;
compare x=(year)
		y=isweights / loess; 
run; quit;
ods graphics off;



proc contents data=steel;
run;
proc print data=steel (obs=20);
run;
PROC SGPLOT DATA=STEEL;
SERIES x=YEAR y=isweights;
RUN;
proc sgplot data=steel;
SCATTER y=isweights x=year;
REG y=isweights x=year / CLM;
LOESS y=isweights x=year;
run;
PROC ARIMA data=steel;
IDENTIFY var=isweights SCAN ESACF MINIC STATIONARITY=(RANDOMWALK) NLAG=10;
Run;
ESTIMATE P=1 PLOT GRID;
OUTLIER ID=YEAR;
run;
PROC ARIMA data=steel;
IDENTIFY var=isweights (1) SCAN ESACF MINIC STATIONARITY=(RANDOMWALK) NLAG=10;
Run;
ESTIMATE P=1 PLOT GRID;
OUTLIER ID=YEAR;
run;
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