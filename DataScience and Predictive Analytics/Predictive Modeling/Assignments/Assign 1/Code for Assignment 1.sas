*Daniel Prusinski Assignment 1******************************
************************************************************
***********************************************************;

libname mydata '/courses/u_northwestern.edu1/i_833463/c_3505/SAS_Data/';

*****This program will run Perason CC and create a scatter plot matrix of all the data points*****;
ods graphics on;
title "computing Pearson CC";
proc corr data=mydata.building_prices nosimple rank
	plots = matrix(histogram nvar=all);
run;
ods graphics off;

*****This program will create a scatterplot for each variable on its own page*****;
ods graphics on;
title "computing Pearson CC";
proc corr data=mydata.building_prices nosimple rank plots (only)=scatter (nvar=all);
	var x1 x2 x3 x4 x5 x6 x7 x8 x9;
	with y;
run;
ods graphics off;

*****This program creates the LOESS smoother for Y with each of the predictor variables*****;
ods graphics on;
title "LOESS Smoother for Y";
proc sgplot data=mydata.building_prices;
	Loess x=x1 y=y;
run; quit;
ods graphics off;

ods graphics on;
title "LOESS Smoother for Y";
proc sgplot data=mydata.building_prices;
	Loess x=x2 y=y;
run; quit;
ods graphics off;

ods graphics on;
title "LOESS Smoother for Y";
proc sgplot data=mydata.building_prices;
	Loess x=x3 y=y;
run; quit;
ods graphics off;

ods graphics on;
title "LOESS Smoother for Y";
proc sgplot data=mydata.building_prices;
	Loess x=x4 y=y;
run; quit;
ods graphics off;

ods graphics on;
title "LOESS Smoother for Y";
proc sgplot data=mydata.building_prices;
	Loess x=x5 y=y;
run; quit;
ods graphics off;

ods graphics on;
title "LOESS Smoother for Y";
proc sgplot data=mydata.building_prices;
	Loess x=x6 y=y;
run; quit;
ods graphics off;

ods graphics on;
title "LOESS Smoother for Y";
proc sgplot data=mydata.building_prices;
	Loess x=x7 y=y;
run; quit;
ods graphics off;

ods graphics on;
title "LOESS Smoother for Y";
proc sgplot data=mydata.building_prices;
	Loess x=x8 y=y;
run; quit;
ods graphics off;

ods graphics on;
title "LOESS Smoother for Y";
proc sgplot data=mydata.building_prices;
	Loess x=x9 y=y;
run; quit;