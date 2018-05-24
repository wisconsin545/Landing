/*  This Page is for defining the tasks done:
Descriptive Stats -Cody page 21...
Histogram using Proc Univariate  */

/*  Define the library names */
libname mydata "/courses/u_northwestern.edu1/i_829657/c_4884" access=readonly;

/*  Read in the data */
data rockinweek1;
    set mydata.airlines_week_1;
    y=log(c);
    log_q=log(q);
    log_pf=log(pf);
run;

*****This program will run descriptive statistics using proc means*****;
ods graphics on;
title "Descriptive Statistics using Proc Means";
proc means data=rockinweek1 n nmiss min max median mean variance std maxdec=3;
	var y c log_q q log_pf pf LF;
run;

ods graphics on;
title "Descriptive Statistics using Proc Means";
proc means data=rockinweek1 n nmiss min max median mean variance std maxdec=3;
	var y c;
run;

ods graphics on;
title "Descriptive Statistics using Proc Means";
proc means data=rockinweek1 n nmiss min max median mean variance std maxdec=3;
	var log_q q ;
run;

ods graphics on;
title "Descriptive Statistics using Proc Means";
proc means data=rockinweek1 n nmiss min max median mean variance std maxdec=3;
	var log_pf pf;
run;

ods graphics on;
title "Descriptive Statistics using Proc Means";
proc means data=rockinweek1 n nmiss min max median mean variance std maxdec=3;
	var LF;
run;

*****This program will run descriptive statistics / histogram using proc univariate*****;
ods graphics on;
title "Descriptive Statistics using Proc Univariate";
proc univariate data=rockinweek1;
	var y c log_q q log_pf pf LF;
	histogram / normal; 
	probplot / normal (mu=est sigma=est);
run;

*****This program will run Perason CC and create a scatter plot matrix of all the data points*****;
ods graphics on;
title "computing Pearson CC";
proc corr data=rockinweek1 nosimple rank
	plots = matrix(histogram nvar=all);
run;

*****This program will run a box plot labeling outliers*****;
title "Box Plot with Outliers Labeled";
proc sgplot data=rockinweek1;
	hbox y q / datalabel;
run;