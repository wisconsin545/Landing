
*Daniel Prusinski Assignment 1******************************
************************************************************
***********************************************************;

*****Statement to access where the data is stored*****;
libname mydata '/courses/u_northwestern.edu1/i_833463/c_3505/SAS_Data/';

*****Let's have a look at the data*****;
proc print data=mydata.building_prices;
run;

*****Let's take a look at the Metadata*****;
proc contents data=mydata.building_prices;
run;

***** P 112 of SAS by Example: This program will run Perason CC and create a scatter plot matrix of all the data points*****;
ods graphics on;
title "computing Pearson CC";
proc corr data=mydata.building_prices nosimple rank
	plots = matrix(histogram nvar=all);
run;

*****This program will create a scatterplot for each variable on its own page*****;
title "computing Pearson CC";
proc corr data=mydata.building_prices nosimple rank plots (only)=scatter (nvar=all);
	var x1 x2 x3 x4 x5 x6 x7 x8 x9;
	with y;
run;

*****This program creates the LOESS smoother for Y with each of the predictor variables*****;
title "Scatter Plot with Loess Smoother X1, X2, X3";
proc sgscatter data=mydata.building_prices;
compare x = (x1 x2 x3)
y=Y / loess;
run;

title "Scatter Plot with Loess Smoother X4, X5, X6";
proc sgscatter data=mydata.building_prices;
compare x = (x4 x5 x6)
y=Y / loess;
run;

title "Scatter Plot with Loess Smoother X7, X8, X9";
proc sgscatter data=mydata.building_prices;
compare x = (x7 x8 x9)
y=Y / loess;
run;
