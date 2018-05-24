 
*Daniel Prusinski Assignment 1 V3***************************
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
*****This program will run Perason CC and create a scatter plot matrix of all the data points*****;
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
ods graphics on;
%macro loewx(var1);
title "LOESS Smoother for Y and &var1";
proc sgplot data=mydata.building_prices;
	Loess x=&var1 y=y;
run; 
%mend;

%leowx(x1);
%leowx(x2);
%leowx(x3);
%leowx(x4);
%leowx(x5);
%leowx(x6);
%leowx(x7);
%leowx(x8);
%leowx(x9);
