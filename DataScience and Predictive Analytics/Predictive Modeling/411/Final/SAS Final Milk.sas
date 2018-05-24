*/
proc print data=work.milk;

data fun;
	set work.milk;
	where year < 1975;
	run;

data final;
	set work.milk;
	where year < 1975;
	ln_m=log(milk);
	run; 
	
data remainder;
	set work.milk;
	where year > 1974;
	ln_m=log(milk);
	run; 
	

*/
proc print data=final;


*****Initial Desriptive Statistics*****;
/*
proc univariate data=final;
	var milk ln_m;
	histogram / normal; 
run;
*/

*****Time Series Plot*****;
/*
title "Time Series Plot of Milk";
title2 "Milk is Pounds Per Cow";
title3 "1962 -1974";
PROC SGPLOT DATA=final;
SERIES x=year y=milk;
RUN;

title "Time Series Plot of Milk";
title2 "Milk is Pounds Per Cow";
title3 "1962 -1974";
PROC SGPLOT DATA=final;
SERIES x=month y=milk;
RUN;


proc sgplot data=final;
SCATTER y=milk x=date;
REG y=milk x=date / CLM;
LOESS y=milk x=date;
run;
*/

*****Make the Data Stationary*****;
*****Initial Proc Arima*****;
/*
proc arima data=final;
	identify var=milk (1, 12);
	run;
*/

/*
*****Assess which model to choose*****;
proc arima data=final;
	identify var=milk (1, 12);
	estimate;
	run;
*/

*****Fit the AR Model*****;
/*  Multiplicative AR model */
/*
proc arima data=final;
    identify var=milk(1,12);
    estimate p=(1)(12);
run;

*****Fit the MA Model*****;
proc arima data=final;
    identify var=milk(1,12);
    estimate q=(1)(12);
run;

*****Fit the ARMA Model*****;
proc arima data=final;
    identify var=milk(1,12);
    estimate p=(1)(12) q=(1) (12);
run;
*/

*****THE MA model is the best, let's forecast 10 periods ahead*****;
*****Fit the MA Model*****;
proc arima data=final;
    identify var=milk(1,12);
    estimate q=(1)(12);
    forecast lead=12;
run;

*****Predict the AR Model*****;
proc arima data=final;
    identify var=milk(1,12);
    estimate p=(1)(12);
    forecast lead=12;
run;

*****Predict the ARMA Model*****;
proc arima data=final;
    identify var=milk(1,12);
    estimate p=(1)(12)q=(1) (12);
    forecast lead=12;
run;

*****Print out the output for 1975*****;
title "Time Series Plot of Milk";
title2 "Milk is Pounds Per Cow";
title3 "1962 -1974";
PROC SGPLOT DATA=remainder;
SERIES x=date y=milk;
RUN;