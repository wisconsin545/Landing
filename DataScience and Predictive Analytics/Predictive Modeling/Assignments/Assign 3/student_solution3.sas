/* 	Chad R. Bhatti
	07.14.2012
	student_solution3.sas
*/


libname mydata 	'/courses/u_northwestern.edu1/i_833463/c_3505/SAS_Data/' access=readonly; 

/*
proc contents data=mydata.building_prices; run; quit;
proc print data=mydata.building_prices(obs=5); run; quit;
*/

data temp;
	set mydata.building_prices;
	
	if (X2=1.5) then bath_dummy=1;
	else bath_dummy=0;
run;


/*
* Base model from Assignment #2;
proc reg data=temp;
model y = x1;
title 'Base Model';
run;
*/

/*
proc reg data=temp;
model y = x1-x9 / selection=forward;
title 'Forward Model Selection';
run;
*/

/*
proc reg data=temp;
model y = x1-x9 / selection=backward;
title 'Backward Model Selection';
run;
*/


/*
proc reg data=temp;
model y = x1-x9 / selection=stepwise;
title 'Stepwise Model Selection';
run;
*/

* Use a variable selection method that penalized for model complexity;
proc reg data=temp;
model y = x1-x9 / selection=adjrsquared cp aic bic best=5;
title 'Complexity Based Model Selection';
run;


ods graphics on;
* Note: fitplot is not a valid option for multiple regression;
proc reg data=temp plots=(fitplot residuals diagnostics);
model y=x1 x2 / vif ;
title 'Optimal Regression Model';
output out=fitted_model pred=yhat residual=resid ucl=ucl lcl=lcl;
run;
ods graphics off;


ods graphics on;
* Note: fitplot is not a valid option for multiple regression;
proc reg data=temp plots=(fitplot residuals diagnostics);
model y=x1 bath_dummy / vif ;
title 'Optimal Regression Model';
output out=fitted_model pred=yhat residual=resid ucl=ucl lcl=lcl;
run;
ods graphics off;



/* Some Comments:

(1) As indicated in the variable selection tutorial, the variable selection
methods return different models because the default values for SLENTRY and
SLSTAY are different for each method.  If we sync up those values, then the models
should be the same or very similar.

(2) The Variance Inflation Factors are not an issue in this assignment.  The book
will tell you that a VIF greater than 10 should be a concern, but a more realistic
value is 3.  VIF(Xk) = 1 / (1 - R2(Xk ~ {Xi\Xk})).  A value of 3 means that Xk has a 
R-squared of ~0.6 when regressed on the other predictor variables.

(3) Generally speaking we should code X2 as a dummy variable and fit the model.  We have
a unique result in this example since the ANOVA table for the in-sample model fit is the 
same for both models.  Note that these models are not the same.  They have a different
structure and different coefficients.  If we had a bigger sample, then we could 
evaluate these models out-of-sample, and we would find their out-of-sample performance to 
be different even though their in sample performance was the same.
