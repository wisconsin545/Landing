libname mydata56 "/courses/u_northwestern.edu1/i_829657/c_4884" access=readonly;

/*  Read in the Wine data from the Work library */
data wine;
  set mydata56.Wine_Week_8;
  sales=Kiloliters_in_1000_s_;
  id=_n_;
run;
proc contents data=mydata57.Wine_Week_8;
run;
proc print data=wine;
run;

/*  Plot the data to get a sense of the underlying distribution_process */
PROC SGPLOT DATA=wine;
    SERIES x=id y=sales;
RUN;
/*  The plot of the original data indicates some indication of increased variability over time
    and so a natural log transformation is a first attempt at getting to a stationary model */
data t_wine;
    set wine;
    log_sales=log(sales);
run;
proc sgplot data=t_wine;
    title "Time Series Plot of the Australian Wine Sales dataset";
    title2 "Time Series Variable is Log of Sales";
    series x=id y=log_sales;
run;
/*  Note that the variability appears to have stabilized but there is still a clear trend */
/*  Let's try taking the first difference to see if the trend can be removed */
proc arima data=t_wine;
    identify var=log_sales(1) nlag=36;
run;
/*  The trend is definitely removed.  However, the seasonality is not.  Let's take a */
/*  span 1 and span 12 differencing just like we did in the airlines data set */
proc arima data=t_wine;
    identify var=log_sales(1, 12) nlag=36;
run;
/*  Let's try the multiplicative models */
/*  Multiplicative AR model */
proc arima data=t_wine;
    identify var=log_sales(1,12);
    estimate p=(1)(12);
run;
/*  Multiplicative MA model */
proc arima data=t_wine;
    identify var=log_sales(1,12);
    estimate q=(1)(12);
run;
/*  Multiplicative ARMA model */
proc arima data=t_wine;
    identify var=log_sales(1,12);
    estimate p=(1)(12) q=(1)(12);
run;