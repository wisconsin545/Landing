/* 	Chad R. Bhatti
	04.13.2012
	student_solution2.sas
*/


libname mydata 	'/courses/u_northwestern.edu1/i_833463/c_3505/SAS_Data/' access=readonly; 

/*
proc contents data=mydata.building_prices; run; quit;
proc print data=mydata.building_prices(obs=5); run; quit;
*/

data temp;
	set mydata.building_prices;
run;

/* Need to be careful about 'ods graphics on' statement.
Be sure to close each 'ods graphics on' statement with a 'ods graphics off'
statement.
*/
 
* Find the optimal single predictor model;
proc reg data=temp;
model y = x1-x9 / selection=rsquare start=1 stop=1;
run;


* Produce the goodness-of-fit diagnostics for the optimal regression model;
ods graphics on;
proc reg data=temp plots=(fitplot residuals diagnostics);
model y=x1;
title 'Regression Model of Home Price On Taxes';
run;
ods graphics off;


/* Primary Diagnostics:

(1) Check the QQ plot to ensure that the residuals are normally distributed.
Residuals should hug the 45 degree line.  In this example we probably have one
(very) mild outlier, which we can see by looking at the Cook's D measure.  
See p. 111 in RABE for Cook's Distance.  A simple rule is a Cook's D greater 
than 1 is an influential point, where "influential point" means that the 
observation effects the estimation of the regression coefficients.

(2) Examine the individual plots of the residuals against the predictor variables
to check for mis-specification in the predictor.  If the plots do not show a 
pattern, then the predictor specification is okay.  If the plots show a pattern,
then you would need to try to transformation of the predictor variable to remove
the pattern.  A pattern in this plot indicates a volation of the homoscedasticity 
assumption.  The transformation to remove this pattern is called a 
"variance-stabilizing transformation".  


(3) Model is reasonably predictive in-sample with an adjusted R-Square of 0.753.

Our goodness-of-fit analysis allows us to have confidence that any statistical 
inferences made from this model would be statistically valid, i.e. all p-values
are legitimate and not distorted by model mis-specification.  However, the 
goodness-of-fit analysis does not allow us to conclude that the model is good 
enough from a predictive accuracy or application point-of-view.  We would have to 
determine what level of accuracy is necessary for our application, and then 
evaluate our model out-of-sample to determine if the model fits well enough to be
used for predictive purposes.

*/
****************************************************************;





















