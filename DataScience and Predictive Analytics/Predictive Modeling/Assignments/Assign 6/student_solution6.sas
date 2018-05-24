/* 	Chad R. Bhatti
	04.16.2012
	solution6.sas
*/

libname mydata 	'/courses/u_northwestern.edu1/i_833463/c_3505/SAS_Data/' access=readonly; 
title ;

proc contents data=mydata.credit_approval; run; quit;
proc print data=mydata.credit_approval(obs=5); run; quit;


* Create the response variable Y and dummy variables for the categorical predictor
variables;
data temp;
	set mydata.credit_approval;
	
	* Flag the observations as training/testing;
	* Since we set the seed value to 123, we will get the same set of random numbers
	every time and we will all get the same set of random numbers;
	u=uniform(123);
	if (u<0.7) then train=1; else train=0;
	
	if A16='+' then Y=1; 
	else if A16='-' then Y=0;
	else Y=.;
	
	* Create a response indicator based on the training/testing split;
	if (train=1) then Y_train=Y; else Y_train=.;
	
	* A1 Base category is A1='a';
	if (A1='b') then A1_b=1; else A1_b=0;
	* A4 Base category is: l,y;
	if (A4='u') then A4_u=1; else A4_u=0;
	* A5 Base caetgory is: gg,p;
	if (A5='g') then A5_g=1; else A5_g=0;
	
	* These dummy variables for A6 are somewhat arbitrary;
	* I have done this on purpose for discussion purposes;
	* Note that I have lumped some small categories into the base category;
	* A6 takes 14 values;
	* A6 Base category is: d,e,j,r;
	if (A6='aa') then A6_aa=1; else A6_aa=0;
	if (A6='c')  then A6_c=1; else A6_c=0;
	if (A6='cc') then A6_cc=1; else A6_cc=0;
	if (A6='ff') then A6_ff=1; else A6_ff=0;
	if (A6='i')  then A6_i=1; else A6_i=0;
	if (A6='k')  then A6_k=1; else A6_k=0;
	if (A6='m')  then A6_m=1; else A6_m=0;
	if (A6='q')  then A6_q=1; else A6_q=0;
	if (A6='w')  then A6_w=1; else A6_w=0;
	if (A6='x')  then A6_x=1; else A6_x=0;
	
	* A7 Base category is: dd,j,n,o,z;
	if (A7='bb') then A7_bb=1; else A7_bb=0;
	if (A7='ff') then A7_ff=1; else A7_ff=0;
	if (A7='h')  then A7_h=1; else A7_h=0;
	if (A7='v')  then A7_v=1; else A7_v=0;
	
	if (A9='t')  then A9_t=1; else A9_t=0;
	if (A10='t') then A10_t=1; else A10_t=0;
	if (A12='t') then A12_t=1; else A12_t=0;
	
	* A13 Base category is: p,s;
	if (A13='g') then A13_g=1; else A13_g=0;
	
	
	*****************************************************************;
	* Discretize the continuous variables for EDA;
	*****************************************************************;
	* I will include the continuous variables into the model as
	continuous variables.  If you want to include them in the model
	as discrete variables, then you would need to create a family of 
	dummy variables for each of these discretizations.;
	if (A2 < 20) then A2_discrete=1;
	else if (A2 < 25) then A2_discrete=2;
	else if (A2 < 35) then A2_discrete=3;
	else if (A2 < 45) then A2_discrete=4;
	else A2_discrete=5;

	if (A3 < 1) then A3_discrete=1;
	else if (A3 < 2) then A3_discrete=2;
	else if (A3 < 5) then A3_discrete=3;
	else if (A3 < 10) then A3_discrete=4;
	else A3_discrete=5;
	
	if (A8 < 0.5) then A8_discrete=1;
	else if (A8 < 1) then A8_discrete=2;
	else if (A8 < 2) then A8_discrete=3;
	else if (A8 < 5) then A8_discrete=4;
	else if (A8 < 10) then A8_discrete=5;
	else A8_discrete=6;
	
	if (A11 < 1) then A11_discrete=1;
	else if (A11 < 3.01) then A11_discrete=2;
	else A11_discrete=3;

	if (A14 < 100) then A14_discrete=1;
	else if (A14 < 150) then A14_discrete=2;
	else if (A14 < 250) then A14_discrete=3;
	else if (A14 < 350) then A14_discrete=4;
	else A14_discrete=5;

	if (A15 < 1.5) then A15_discrete=1;
	else if (A15 < 50) then A15_discrete=2;
	else if (A15 < 100) then A15_discrete=3;
	else if (A15 < 200) then A15_discrete=4;
	else if (A15 < 4000) then A15_discrete=5;
	else A15_discrete=6;
	
	* Define two dummy variables for continuous variables;
	* These are for example purposes;	
	if (A15 < 200) then A15_dummy=0; else A15_dummy=1;
	if (A11 < 1) then A11_dummy=0; else A11_dummy=1;
	
	* Delete the observations with missing values;
	if (A1='?') or (A4='?') or (A5='?') or (A6='?') or (A7='?') 
	or (A2=.) or (A3=.) or (A8=.) or (A11=.) or (A14=.) or (A15=.)
	then delete;
	
run;
	

proc freq data=temp;
tables Y;
run;

proc freq data=temp;
tables train;
run;

proc freq data=temp;
tables train*Y;
run;


*********************************************************************************;
* Optimal Model from Backward Variable Selection;
*********************************************************************************;
* Train the model on the training data and score the testing data all in one step.;
proc logistic data=temp descending;
model Y_train = A2 A3 A8 A11 A14 A15
	A1_b A4_u A5_g 
	A6_aa A6_c A6_cc A6_ff A6_i A6_k A6_m A6_q A6_w A6_x 
	A7_bb A7_ff A7_h A7_v
	A9_t A10_t A12_t A13_g / selection=backward;
	output out=model_data pred=yhat;
run;


proc print data=model_data(obs=10); run;

data pdata;
	set model_data (keep= train Y Y_train yhat);
run;

proc print data=pdata(obs=30); run;


title 'Model #1: In-Sample Lift Chart';
* descending option means that the highest model scores are assigned 
to the lowest score_decile;
proc rank data=model_data out=training_scores descending groups=10;
var yhat;
ranks score_decile;
where train=1;
run;

proc print data=training_scores(obs=5); run;


* Create lift chart;
* Run this exact code;
proc means data=training_scores sum;
class score_decile;
var Y;
output out=pm_out sum(Y)=Y_Sum;
run;


proc print data=pm_out; run;

data lift_chart;
	set pm_out (where=(_type_=1));
	by _type_;
	Nobs=_freq_;
	score_decile = score_decile+1;
	
	if first._type_ then do;
		cum_obs=Nobs;
		model_pred=Y_Sum;
	end;
	else do;
		cum_obs=cum_obs+Nobs;
		model_pred=model_pred+Y_Sum;
	end;
	retain cum_obs model_pred;
	 
	pred_rate=model_pred/201; *you will need to change this value to be the number of successes;
	base_rate=score_decile*0.1;
	lift = pred_rate-base_rate;
	
	drop _freq_ _type_ ;
run;

proc print data=lift_chart; run;


ods graphics on;
title 'Model #1: In-Sample Lift Chart';
symbol1 color=red interpol=join value=dot height=1;
symbol2 color=black interpol=join value=dot height=1;
proc gplot data=lift_chart;
plot pred_rate*base_rate base_rate*base_rate /overlay ;
run; quit;
ods graphics off;

/* How do we interpret this lift chart?;

Note:  This version of a "lift chart" is the version that most statisticians use.  This is
the only "lift chart" that is based on a statistical concept - the Kolmogorov-Smirnov test
for equality of distributions.  The maximum lift in this chart corresponds to the KS 
statistic.  People usually reference this statistic, but they never show it's p-value 
because the KS statistic has a strange distribution that is determined by whether the 
sample size is even or odd.  Since the concept of "lift" is heuristic, others may show
a variety of charts and call them a "lift chart".  They may also refer to this chart as a
"cumulative gains chart".


Typically we show both the table and the plot.  The table shows me that you know what you 
are doing, i.e. you have computed the cumulative distributions correctly.  Note that all that
we are doing is computing the cdf of the number of Y=1 by the score.  

The plot is better if we add some specific information to it like the maximum lift.
*/


/* To complete your assignment see if these results hold out-of-sample (check the testing sample);

* Note that no model was fit to the testing sample.  This is out-of-sample.  
We check the out-of-sample model performance as a means to guard against over-fitting.
Our 70/30 training/testing data split is a simple version of cross-validation.

Follow the same modeling procedure as OLS, exploraroty analysis:
Model identification
Goodness of fit
When Predicting - Out of Sample matters / Cross Validation
AUC and Lift Chart used to assess predictive accuracy.

Coding Dummy Variables: You need to code any categorical variable as a dummy 
variables. This needs to be done in any of the regression techniques like survival,
OLS, and logistic. 

Quantiles form distributions. It's very common to discritize continous variables,
this puts data into bins and is very common. 

Variables selection uses some criteria to assess the variables. 














*/

title 'Model #1: Out-Of-Sample Lift Chart';
proc rank data=model_data out=testing_scores descending groups=10;
var yhat;
ranks score_decile;
where train=0;
run;

proc means data=testing_scores sum;
class score_decile;
var Y;
output out=pm_out sum(Y)=Y_Sum;
run;


proc print data=pm_out; run;

data lift_chart;
	set pm_out (where=(_type_=1));
	by _type_;
	Nobs=_freq_;
	score_decile = score_decile+1;
	
	if first._type_ then do;
		cum_obs=Nobs;
		model_pred=Y_Sum;
	end;
	else do;
		cum_obs=cum_obs+Nobs;
		model_pred=model_pred+Y_Sum;
	end;
	retain cum_obs model_pred;
	 
	pred_rate=model_pred/95; *you will need to change the 95;
	base_rate=score_decile*0.1;
	lift = pred_rate-base_rate;
	
	drop _freq_ _type_ ;
run;

proc print data=lift_chart; run;


ods graphics on;
title 'Model #1: Out-Of-Sample Lift Chart';
symbol1 color=red interpol=join value=dot height=1;
symbol2 color=black interpol=join value=dot height=1;
proc gplot data=lift_chart;
plot pred_rate*base_rate base_rate*base_rate /overlay ;
run; quit;
ods graphics off;


*********************************************************************************;
* Manager's Model #2;
*********************************************************************************;
* Train the model on the training data and score the testing data all in one step.;
proc logistic data=temp descending;
model Y_train = A9_t A2 A3;
	output out=model_data2 pred=yhat;
run;


proc print data=model_data2(obs=10); run;

data pdata;
	set model_data2 (keep= train Y Y_train yhat);
run;

proc print data=pdata(obs=30); run;


title 'Model #2: In-Sample Lift Chart';
* descending option means that the highest model scores are assigned 
to the lowest score_decile;
proc rank data=model_data2 out=training_scores descending groups=10;
var yhat;
ranks score_decile;
where train=1;
run;

proc print data=training_scores(obs=5); run;


* Create lift chart;
* Run this exact code;
proc means data=training_scores sum;
class score_decile;
var Y;
output out=pm_out sum(Y)=Y_Sum;
run;


proc print data=pm_out; run;

data lift_chart;
	set pm_out (where=(_type_=1));
	by _type_;
	Nobs=_freq_;
	score_decile = score_decile+1;
	
	if first._type_ then do;
		cum_obs=Nobs;
		model_pred=Y_Sum;
	end;
	else do;
		cum_obs=cum_obs+Nobs;
		model_pred=model_pred+Y_Sum;
	end;
	retain cum_obs model_pred;
	 
	pred_rate=model_pred/201; *you will need to change this value to be the number of successes;
	base_rate=score_decile*0.1;
	lift = pred_rate-base_rate;
	
	drop _freq_ _type_ ;
run;

proc print data=lift_chart; run;


ods graphics on;
title 'Model #2: In-Sample Lift Chart';
symbol1 color=red interpol=join value=dot height=1;
symbol2 color=black interpol=join value=dot height=1;
proc gplot data=lift_chart;
plot pred_rate*base_rate base_rate*base_rate /overlay ;
run; quit;
ods graphics off;


title 'Model #2: Out-Of-Sample Lift Chart';
proc rank data=model_data out=testing_scores descending groups=10;
var yhat;
ranks score_decile;
where train=0;
run;

proc means data=testing_scores sum;
class score_decile;
var Y;
output out=pm_out sum(Y)=Y_Sum;
run;


proc print data=pm_out; run;

data lift_chart;
	set pm_out (where=(_type_=1));
	by _type_;
	Nobs=_freq_;
	score_decile = score_decile+1;
	
	if first._type_ then do;
		cum_obs=Nobs;
		model_pred=Y_Sum;
	end;
	else do;
		cum_obs=cum_obs+Nobs;
		model_pred=model_pred+Y_Sum;
	end;
	retain cum_obs model_pred;
	 
	pred_rate=model_pred/95; *you will need to change the 95;
	base_rate=score_decile*0.1;
	lift = pred_rate-base_rate;
	
	drop _freq_ _type_ ;
run;

proc print data=lift_chart; run;


ods graphics on;
title 'Model #2: Out-Of-Sample Lift Chart';
symbol1 color=red interpol=join value=dot height=1;
symbol2 color=black interpol=join value=dot height=1;
proc gplot data=lift_chart;
plot pred_rate*base_rate base_rate*base_rate /overlay ;
run; quit;
ods graphics off;