

libname mydata56 "/courses/u_northwestern.edu1/i_829657/c_4884" access=readonly;

/*  Read in the Wine data from the Work library */
data wine;
  set mydata56.Wine_Week_8;
  sales=Kiloliters_in_1000_s_;
  id=_n_;
run;

data t_wine;
    set wine;
    log_sales=log(sales);
run;

*****THE MA model is the best, let's forecast 10 periods ahead*****;
proc arima data=t_wine;
  identify var=log_sales(1,12);
    estimate q=(1)(12);
    forecast lead=10;
run;


*****Now fit the model with the different types*****;
*  Let's try the multiplicative models */

/*  Multiplicative MA model */
proc arima data=t_wine;
proc arima data=t_wine;
    identify var=log_sales(1,12);
    estimate q=(1)(12);
run;

/*  Multiplicative AR model */
proc arima data=t_wine;
    identify var=log_sales(1,12);
    estimate p=(1)(12);
run;

/*  Multiplicative ARMA model */
proc arima data=t_wine;
    identify var=log_sales(1,12);
    estimate p=(1)(12) q=(1)(12);
run;

*****Initial Proc Arima*****;
proc arima data=t_wine;
	identify var=log_sales;
	run;

/*  span 2 */
proc arima data=t_wine;
    identify var=log_sales(1) nlag=36;
run;


/*  span 1 and span 12 differencing just like we did in the airlines data set */
proc arima data=t_wine;
    identify var=log_sales(1, 12) nlag=36;
run;



*****Log Transformation*****
The plot of the original data indicates some indication of increased variability over time
    and so a natural log transformation is a first attempt at getting to a stationary model.
    Nope, this does not stationarize the data;
proc sgplot data=t_wine;
    title "Time Series Plot of the Australian Wine Sales dataset";
    title2 "Time Series Variable is Log of Sales";
    series x=id y=log_sales;
run;

*****Scatter Plot and Loess*****;
proc sgplot data=wine;
SCATTER y=sales x=id;
run;

proc sgplot data=wine;
REG y=sales x=id / CLM;
run;

proc sgplot data=wine;
LOESS y=sales x=id;
run;

*****Initial Desriptive Statistics*****;
proc univariate data=wine;
	var sales;
	histogram / normal; 
run;

*****Scatter Plot for Log Transformation*****;
proc sgplot data=wine;
SCATTER y=sales x=id;
REG y=sales x=id / CLM;
LOESS y=sales x=id;
run;


*****Proc Univariate on Log Sales*****;
*****Initial Desriptive Statistics*****;
proc univariate data=t_wine;
	var log_sales;
	histogram / normal; 
run;
