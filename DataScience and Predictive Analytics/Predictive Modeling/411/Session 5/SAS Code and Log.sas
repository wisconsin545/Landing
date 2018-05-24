/*  This is the program given on page 134 through the top of page 135 and produces Output 8.1 */

libname mydata56 "/courses/u_northwestern.edu1/i_829657/c_4884" access=readonly;
data GM CH GE WE US;
	set mydata56.grun_week_5;
	if firm=1 then output GM;
	else if firm=2 then output CH;
	else if firm=3 then output GE;
	else if firm=4 then output WE;
	else output US;
run;
data GM;
	set GM;
	rename i=i_gm f=f_gm c=c_gm;
run;
data CH;
	set CH;
	rename i=i_ch f=f_ch c=c_ch;
run;
data GE;
	set GE;
	rename i=i_ge f=f_ge c=c_ge;
run;
data WE;
	set WE;
	rename i=i_we f=f_we c=c_we;
run;
data US;
	set US;
	rename i=i_us f=f_us c=c_us;
run;
data grunfeld;
	merge gm ch ge we us;
	by year;
run;

*****This program will run descriptive statistics using proc means*****;
ods graphics on;
title "Descriptive Statistics using Proc Means";
proc means data=mydata56.grun_week_5 n nmiss min max median mean variance std maxdec=3;
	var i f c;
run;

proc univariate data=mydata56.grun_week_5;
	var i f c;
	histogram / normal; 
	probplot / normal (mu=est sigma=est);
run;


*****Research Models*****; 
proc reg data=GM;
    model i_gm = f_gm c_gm; 
run;

 proc reg data=CH;   
    model i_ch = f_ch c_ch;
run;

proc reg data=GE;
    model i_ge = f_ge c_ge;
run;

proc reg data=WE; 
    model i_we = f_we c_we;
    
proc reg data=US;
	model i_us = f_us c_us;
run;
/*  This is the program given on the bottom of page 135 to the top of page 140 and produces output 8.2 */
proc syslin data=grunfeld SUR; 
      gm:      model i_gm = f_gm c_gm; 
      ch: 	   model i_ch = f_ch c_ch;
      ge:      model i_ge = f_ge c_ge; 
      we: 	   model i_we = f_we c_we;
	  us:      model i_us = f_us c_us;
run;
 
 *****The sea of OLS models*****;
 proc reg data=mydata56.grun_week_5;
	model I=F C / VIFS;
run;



*****This program will run descriptive statistics using proc means*****;
ods graphics on;
title "Descriptive Statistics using Proc Means";
proc means data=mydata56.grun_week_5 n nmiss min max median mean variance std maxdec=3;
	var i f c;
run;

proc univariate data=mydata56.grun_week_5 maxdec=3;
	var i f c;
	histogram / normal; 
	probplot / normal (mu=est sigma=est);
run;

*****Log*****;
/*:
Results folder: C:\Users\dprusins\AppData\Local\Temp\JMP_SAS_Results\Submit_1226 