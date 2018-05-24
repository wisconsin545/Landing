/*  This Page is for minor programs to supplement the assignment */

/*  Define the library names */
libname mydata "/courses/u_northwestern.edu1/i_829657/c_4884" access=readonly;

/*  Read in the data */
data rockinweek1;
    set mydata.airlines_week_1;
    y=log(c);
    log_q=log(q);
    log_pf=log(pf);
run;

*****Using Proc Reg for Residual and Diagnostics VIF*****;
title 'Fits of Regression Analysis';
proc reg data=rockinweek1 plots=(fitplot residuals diagnostics);
	model y = log_q log_pf LF / VIF; 
Run;

ODS graphics on; 
proc reg data=rockinweek1; 
	model y = log_q log_pf LF / VIF;
	output out=resid r=resid;
run;

proc univariate data=resid; 
	var resid; 
	probplot/normal;
run;

data resid;
	set resid;
	T=_n_;
run;

proc gplot data=resid; 	
	plot resid*T;
run;
proc gplot data=resid; 	
	plot resid*log_q;
run;
proc gplot data=resid; 	
	plot resid*log_pf;
run;
proc gplot data=resid; 	
	plot resid*LF;
run;
proc gplot data=resid; 	
	plot resid*y;
run