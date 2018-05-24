*Daniel Prusinski Assignment 3 Version 1********************
************************************************************
***********************************************************;

*****Statement to access where the data is stored*****;
libname mydata '/courses/u_northwestern.edu1/i_833463/c_3505/SAS_Data/';
ods graphics on;

*****Fitting X1*****;
title "Checking which Model is Best";
proc reg data=mydata.building_prices;
	model Y = x1 /
run; 

*****Demonstrating Forward, Backward, and Stepwise Selection Mothods Chapter 9*****;
title "Forward, Backward, and Stepwise Selection Methods";
title 2 "Using Default Values for SLENTRY and SLSTAY";
proc reg data=mydata.building_prices;
	Forward: model Y = x1 x2 x3 x4 x5 x6 x7 x8 x9 /
	selection = forward;
	Backword: model Y = x1 x2 x3 x4 x5 x6 x7 x8 x9 /
	selection = backward;
	Stepwise: model Y = x1 x2 x3 x4 x5 x6 x7 x8 x9 /
	selection = stepwise;
run; 

*****Checking Adjusted RSquare*****;
title "Checking which Model is Best";
proc reg data=mydata.building_prices;
	model Y = x1 x2 x4 x5 x6 x8 x9 /
run; 

*****Fitting X1 and X2*****;
title "Checking which Model is Best";
proc reg data=mydata.building_prices;
	model Y = x1 x2 /
run; 

*****Using Proc Reg for Residual and Diagnostics*****;
title 'Fits of Regression Analysis';
proc reg data=mydata.building_prices plots (only) = (QQplot Diagnostics Residuals);
	model y = x1 x2; 
Run;

*****Using the VIF to Detect Collinearity, 156*****;
proc reg data=mydata.building_prices;
	model y = x1 x2 / VIF;
run;
ODS Graphics off; 

*****Creating Dummy Variables for Regression, 153*****;
data temp;
	set mydata.building_prices;
	if (X2=1.5) then bath_dummy=1;
	else bath_dummy=0;
run;

*****Running regression analysis with diagnostics for X1 and dummy variable****; 
proc reg data=temp; 
	model y = x1 bath_dummy;
	plots (only) = (QQplot Fitplot Diagnostics Residuals); 
run;
ODS Graphics off; 

*****Running regression analysis and diagnostics for X2*****;
proc reg data=mydata.building_prices; 
	model y = x2;
	plots = (Fitplot Diagnostics Residuals); 
run;
ODS Graphics off;

Title "Ratner's Avg Correlation";
proc corr data=mydata.building_prices;
	var x1 x2 x4 x5 x6 x8 x9;
	with x1 x2 x4 x5 x6 x8 x9;
run; 

Title "Pearson CC with Y";
proc corr data=mydata.building_prices;
	var x1 x2 x4 x5 x6 x8 x9;
	with y;
run; 

Title "Ratner's Avg Correlation";
Title 2 "Model 2 Avg Correlation";
proc corr data=mydata.building_prices;
	var x1 x2;
	with x1 x2;
run; 

Title "Pearson CC with Y";
Title 2 "Model 2 Pearson CC";
proc corr data=mydata.building_prices;
	var x1 x2;
	with y;
run; 