/*  Define the library names */
libname mydata56 "/courses/u_northwestern.edu1/i_829657/c_4884" access=readonly;


/*  Read in the data */
data week1;
	set mydata56.airlines_week_1;
	/* Transform the data */
	LnC=log(C);
	LnQ=Log(Q);
	LnPF=Log(PF);
run;

/*  Quality Checks */
proc contents data=week1;
run;
proc print data=week1;
run;

/* Run a pooled regression model */
/* Also generate various residual plots to assess the model fit */

proc reg data=week1; 
	model LnC=LnQ LnPF LF/vif; 
	plot p.*p. uclm.*p. lclm.*p./overlay; 
	plot p.*p. ucl.*p. lcl.*p./overlay; 
	plot student.*p.;
	plot r.*p.;
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
	plot resid*LnQ;
run;
proc gplot data=resid; 	
	plot resid*LnPF;
run;
proc gplot data=resid; 	
	plot resid*LF;
run;
proc gplot data=resid; 	
	plot resid*LnC;
run