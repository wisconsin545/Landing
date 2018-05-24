*Daniel Prusinski Assignment 2 Version 1********************
************************************************************
***********************************************************;

*****Statement to access where the data is stored*****;
libname mydata '/courses/u_northwestern.edu1/i_833463/c_3505/SAS_Data/';
ods graphics on;

*****Program for running a Regression Model, Chapter 9 Cody*****;
Title "Running a Simple Regression Model";
proc reg data=mydata.building_prices;
	model y = x1;
run;

*****Using the RSQUARE Selection Method, 138*****;
Title "Demonstrating the RSQ Selection Method";
proc reg data=mydata.building_prices;
	model y = x1 x2 x3 x4 x5 x6 x7 x8 x9 /
	selection = rsquare cp adjrsq start=1 stop=1;
run; 

*****Program for choosing the best model, 142*****;
title "Generating Plots of R-Square, adjusted R-Square and C(p)";
proc reg data=mydata.building_prices plots (only) = (rsquare adjrsq cp);
	model y = x1 x2 x3 x4 x5 x6 x7 x8 x9 /
	selection = rsquare cp adjrsq best=3;
run;

*****Using Proc Reg for Residual and Diagnostics*****;
title 'Fits of Regression Analysis';
proc reg data=mydata.building_prices plots (only) = (QQplot Fitplot Diagnostics Residuals);
	model y = x1; 
Run;
ODS Graphics off; 

*****Scatter Plot with Just Regression Line, http://www.ats.ucla.edu/stat/sas/modules/graph.htm *****;
ods graphics on; 
symbol1 v=circle c=blue i=r;
Title "Scatter Plot with R-Line";
Proc Gplot data=mydata.building_prices;
	plot y*x1 ;
run;