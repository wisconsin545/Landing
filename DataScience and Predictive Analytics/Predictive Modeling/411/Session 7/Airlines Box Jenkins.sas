/*  Box Jenkins Analysis on Airlines Data from Box/Jenkins */
/*  Read the data---Create the log variable of the number of passengers */
data airline;
	input pass @@;
	id=_n_;
	lpass=log(pass);
	cards;
112  118  132  129  121  135  148  148  136  119  104  118
  115  126  141  135  125  149  170  170  158  133  114  140
  145  150  178  163  172  178  199  199  184  162  146  166
  171  180  193  181  183  218  230  242  209  191  172  194
  196  196  236  235  229  243  264  272  237  211  180  201
  204  188  235  227  234  264  302  293  259  229  203  229
  242  233  267  269  270  315  364  347  312  274  237  278
  284  277  317  313  318  374  413  405  355  306  271  306
  315  301  356  348  355  422  465  467  404  347  305  336
  340  318  362  348  363  435  491  505  404  359  310  337
  360  342  406  396  420  472  548  559  463  407  362  405
  417  391  419  461  472  535  622  606  508  461  390  432
run;
/*  Time Series plot of the number of passengers */
PROC SGPLOT DATA=airline;
	SERIES x=id y=pass;
RUN;
/*  Time Series plot of the log(number of passengers) */
PROC SGPLOT DATA=airline;
	SERIES x=id y=lpass;
RUN;
/*  Time Series plot with trend lines and smoothing */
/*  Original variable followed by the transformed */
proc sgplot data=airline;
	SCATTER y=pass x=id;
	REG y=pass x=id / CLM;
	LOESS y=pass x=id;
run;
proc sgplot data=airline;
	SCATTER y=lpass x=id;
	REG y=lpass x=id / CLM;
	LOESS y=lpass x=id;
run;
/*  Identification Step--No differencing followed by Span 1 differencing */
proc arima data=airline;
	identify var=lpass;
	identify var=lpass(1);
run;
/*  Span 1 difference removes the trend, but we need to adjust for seasonality */
/*  Span 1 and 12 differencing */
proc arima data=airline;
	identify var=lpass(1,12);
run;
/*  Multiplicative AR model */
proc arima data=airline;
	identify var=lpass(1,12);
	estimate p=(1)(12);
run;
/*  Multiplicative MA model */
proc arima data=airline;
	identify var=lpass(1,12);
	estimate q=(1)(12);
run;
/*  Multiplicative ARMA model */
proc arima data=airline;
	identify var=lpass(1,12);
	estimate p=(1)(12) q=(1)(12);
run;