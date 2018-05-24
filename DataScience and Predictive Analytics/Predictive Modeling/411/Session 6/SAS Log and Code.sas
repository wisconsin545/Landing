*****SAS Log*****;
Results folder: C:\Users\DANPRU~1\AppData\Local\Temp\JMP_SAS_Results\Submit_42


/*  Define the library names */
libname mydata56 "/courses/u_northwestern.edu1/i_829657/c_4884" access=readonly;

data gasoline;
	set mydata56.gasoline_week_6;
	Ln_G_Pop=log(G/Pop);
	Ln_pg=Log(Pg);
	Ln_Income=Log(Y);
	Ln_Pnc=Log(Pnc);
	Ln_Puc=Log(Puc);
	Ln_Pp=Log(Ppt);
	Ln_Pn=Log(Pn);
	Ln_Pd=Log(Pd);
	Ln_Ps=Log(Ps);
	t=_n_;
	G_Pop=(G/Pop);
	if year<1974 then id=1;else id=2;
run;

*****Initial Desriptive Statistics*****;
proc univariate data=gasoline;
	var G Pop Ln_G_Pop G_Pop Ln_pg pg Ln_Income Y	Ln_Pnc Pnc	Ln_Puc Puc	Ln_Pp Ppt Ln_Pn Pn 
	Ln_Pd Pd Ln_Ps Ps t;
	histogram / normal; 
run;

/*  This is the program part which produces the outputs on page 94*/
/*  Figure 6.1 was produced using the full model and Figure 6.1 is based on the partial model*/
/*  Comment out the following Proc Reg accordingly*/

proc reg data=gasoline;
	/*Full Model*/
	model Ln_G_Pop=Ln_Pg Ln_Income Ln_Pnc Ln_Puc Ln_Pp Ln_Pn Ln_Pd Ln_Ps t;
	output out=resid r=resid;
run;



goptions reset=global gunit=pct border cback=white
         colors=(black blue green red)
         ftitle=swissb ftext=swiss htitle=3 htext=2;
title 'LS Residuals versus Year';
footnote1 h=2 j=l ' Table F2.1 from Greene';
footnote2
   h=3 j=l '         US Gasoline Data'
   j=r 'Full Model';

symbol1 value=dot
       height=0.5
       cv=red
       ci=blue
       co=green
       width=0.5
	   i=join;

proc gplot data=resid;
   plot resid*year/vref=0 haxis=1960 to 1995 by 5
   haxis=axis1
               vaxis=axis2;
         axis1 label=('Year');
         axis2 label=(angle=90 'Residuals');
run;

/*  These are the programs given on page 97 and produces outputs 6.1--6.3 */
proc autoreg data=gasoline;
	model Ln_G_Pop=Ln_Pg Ln_Income Ln_Pnc Ln_Puc/dwprob godfrey;
run;

proc autoreg data=gasoline;
	model Ln_G_Pop=Ln_Pg Ln_Income Ln_Pnc Ln_Puc/dwprob dw=5;
run;

proc autoreg data=gasoline;
	model Ln_G_Pop=Ln_Pg Ln_Income Ln_Pnc Ln_Puc/nlag=5;
run;

/*  This is the program given on page 102 and produces output 6.4*/
proc autoreg data=gasoline;
	model Ln_G_Pop=Ln_Pg Ln_Income Ln_Pnc Ln_Puc/nlag=1 dw=1 dwprob;
run;

/*  This is the program which produces output 6.5 */
proc autoreg data=gasoline;
	model Ln_G_Pop=Ln_Pg Ln_Income Ln_Pnc Ln_Puc/nlag=2 dw=2 dwprob;
run;

/*  This program produces the MLE estimates of the AR(1) model-Output 6.6*/
proc autoreg data=gasoline;
		model Ln_G_Pop=Ln_Pg Ln_Income Ln_Pnc Ln_Puc/nlag=1 dw=1 dwprob method=ML;
run;

/* This program produces the MLE estimates of the AR(2) model-Output 6.7*/
proc autoreg data=gasoline;
		model Ln_G_Pop=Ln_Pg Ln_Income Ln_Pnc Ln_Puc/nlag=2 dw=2 dwprob method=ML;
run;

/* This program produces the Iterated FGLS estimates of the AR(1) model-Output 6.8*/
proc autoreg data=gasoline;
		model Ln_G_Pop=Ln_Pg Ln_Income Ln_Pnc Ln_Puc/nlag=1 dw=1 dwprob method=ITYW;
run;

/* This program produces the Iterated FGLS estimates of the AR(2) model-Output 6.9*/
proc autoreg data=gasoline;
		model Ln_G_Pop=Ln_Pg Ln_Income Ln_Pnc Ln_Puc/nlag=2 dw=2 dwprob method=ITYW;
run;

/* This is the program set given on pages 103 to the mid of page 104 */
/* It produces Figure 6.3 */

proc reg data=gasoline noprint;
		model Ln_G_Pop=Ln_Pg Ln_Income Ln_Pnc Ln_Puc;
		output out=a r=r_g;
proc autoreg data=gasoline noprint;
		model Ln_G_Pop=Ln_Pg Ln_Income Ln_Pnc Ln_Puc/nlag=2;
  		output out=b r=ra_g;
data c;
		merge a b;
		symbol1 v=point i=join l=1 c=red;
		symbol2 v=point i=join l=33 c=green;
proc gplot data=c;
		plot r_g*year=1 ra_g*year=2/overlay href=0 haxis=1960 to 1995 by 5
		haxis=axis1
        vaxis=axis2;
		axis1 label=('Year');
        axis2 label=(angle=90 'Residuals');
run;

/* This is the program set given on pages 104 (bot) to the mid of page 106 */
/* It produces Figure 6.4 */

proc autoreg data=gasoline noprint;
	model Ln_G_Pop=Ln_Pg Ln_Income Ln_Pnc Ln_Puc/nlag=1;
    output out=a r=r1;
proc autoreg data=gasoline noprint;
	model Ln_G_Pop=Ln_Pg Ln_Income Ln_Pnc Ln_Puc/nlag=2;
    output out=b r=r2;
proc autoreg data=gasoline noprint;
	model Ln_G_Pop=Ln_Pg Ln_Income Ln_Pnc Ln_Puc/nlag=3;
    output out=c r=r3;
proc autoreg data=gasoline noprint;
	model Ln_G_Pop=Ln_Pg Ln_Income Ln_Pnc Ln_Puc/nlag=4;
    output out=d r=r4;
proc autoreg data=gasoline noprint;
	model Ln_G_Pop=Ln_Pg Ln_Income Ln_Pnc Ln_Puc/nlag=5;
    output out=e r=r5;
data f;
	merge a b c d e;
	symbol1 v=point i=join l=1 c=red;
	symbol2 v=point i=join l=33 c=green;
	symbol3 v=point i=join l=40 c=blue;
	symbol4 v=point i=join l=50 c=orange;
	symbol5 v=point i=join l=60 c=purple;
proc gplot data=f;
	title 'Comparing the residuals from the AR(1)--AR(5) models';
	plot r1*year=1 r2*year=2 r3*year=3 r4*year=4 r5*year=5/overlay href=0 haxis=1960 to 1995 by 5
	haxis=axis1
    vaxis=axis2;
	axis1 label=('Year');
    axis2 label=(angle=90 'Residuals');
run;
ods pdf close;

