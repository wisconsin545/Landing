/*  Define the library names */
libname mydata56 "/courses/u_northwestern.edu1/i_829657/c_4884" 
access=readonly;

/*  Read in the data */
data rockinweek2;
    set mydata56.credit_card_week_2;
    incomesq=income*income;
    y=AvgExp;
    if y>0;
run;


/*****OLS Regression Model*****/

proc reg data=rockinweek2;
    model y = Age OwnRent Income IncomeSq;
    output out=for_graphs student=r_s;
run;

proc gplot data=for_graphs;
	plot r_s*y;
run; 

proc print data=rockinweek2;

*****These programs will run descriptive statistics using proc means*****;
ods graphics on;
title "Descriptive Statistics using Proc Means";
proc means data=rockinweek2 n nmiss min max median mean variance std maxdec=3;
	var Age;
run;

ods graphics on;
title "Descriptive Statistics using Proc Means";
proc means data=rockinweek2 n nmiss min max median mean variance std maxdec=3;
	var Income;
run;

ods graphics on;
title "Descriptive Statistics using Proc Means";
proc means data=rockinweek2 n nmiss min max median mean variance std maxdec=3;
	var Incomesq;
run;

ods graphics on;
title "Descriptive Statistics using Proc Means";
proc means data=rockinweek2 n nmiss min max median mean variance std maxdec=3;
	var y;
run;

ods graphics on;
title "Descriptive Statistics using Proc Means";
proc means data=rockinweek2 n nmiss min max median mean variance std maxdec=3;
	var OwnRent;
run;

*****This program will run descriptive statistics using proc univariate*****;
ods graphics on;
title "Descriptive Statistics using Proc Univariate";
proc univariate data=rockinweek2;
	var y Age Income Incomesq OwnRent;
	histogram / normal; 
	probplot / normal (mu=est sigma=est);
run;

/*  This is the program given on page 76 and one that produces output 5.3 */

Data Expense;
    set mydata56.credit_card_week_2;
    incomesq=income*income;
    incomefth=incomesq*incomesq;
    age_or=age*ownrent;
    age_inc=age*income;
    age_incsq=age*incomesq;
    or_income=ownrent*income;
    or_incomesq=ownrent*incomesq;
    incomecube=income*incomesq;
    y=AvgExp;
    If y>0;
run;
 
 /*****This helps me to see that all the variables went through fine*****/
proc print data=expense;

proc model data=Expense;
      parms Const C_Age C_OwnRent C_Income C_IncomeSq ;
      y = Const + C_Age*Age + C_OwnRent*OwnRent + C_Income*Income + C_IncomeSq*Income*Income;
      income_sq = income * income;
      fit y/ white breusch=(1 Income Income_Sq);
run;

/*  This is the program given on page 78 and it produces output 5.4 */

Data Expense;
    set mydata56.credit_card_week_2;
    incomesq=income*income;
    y=AvgExp;
    if y>0;
run;
proc sort data=Expense;
    by income;
run;

proc print data=expense;
Run;


data Expense;
    set Expense;
    if _n_ < 37 then id=1;else id=2;
run;
proc reg data=Expense outest=est noprint;
    model avgexp=age ownrent income incomesq;
    by id;
run;
proc print data=est;
run;

*****This test is without sorting based on income*****;
Data Expense;
    set mydata56.credit_card_week_2;
    incomesq=income*income;
    if avgexp>0;

run;
data Expense;
    set Expense;
    if _n_ < 37 then id=1;else id=2;
run;
proc reg data=Expense outest=est noprint;
    model avgexp=age ownrent income incomesq;
    by id;
run;
proc print data=est;
run;

/*  This is the program given on page 80 and produces output 5.5 */

Data Expense;
    set mydata56.credit_card_week_2;
    incomesq=income*income;
    if avgexp>0;
run;
proc iml;

/*  Read the data into matrices and prep matrices for analysis. */

    use expense;
    read all var {'age' , 'ownrent' ,'income' ,'incomesq' } into X;
    read all var {'avgexp'} into Z;
    read all var {'avgexp' } into y;
    n=nrow(X);
    X=J(n,1,1)||X;
    Z=J(n,1,1)||Z;

/*  Calculate the residuals from OLS. */

    bhat_OLS=inv(X`*X)*X`*y;
    SSE=(y-X*bhat_OLS)`*(y-X*bhat_OLS);
    resid=y-X*bhat_OLS;

/*  Calculate the LM statistic and associated p value. */

    g=J(n,1,0);
    fudge=SSE/n;
    do index=1 to n;
        temp1=resid[index,1]*resid[index,1];
        g[index,1]=temp1/fudge - 1;
    end;
    LM=0.5*g`*Z*inv(Z`*Z)*Z`*g;
    kz=ncol(Z);
    kz=kz-1;
    pval=1-probchi(LM,kz);
    if (pval<0.05) then
        do;
         print 'The Breusch Pagan Test Statistic Value is 'LM;
         print 'The p value associated with this is 'pval;
         print 'The null hypothesis of homoscedasticity is rejected';
        end;
    else
        do;
         print 'The Breusch Pagan Test Statistic Value is 'LM;
         print 'The p value associated with this is 'pval;
         print 'The null hypothesis of homoscedasticity is not rejected';
        end;
run;
***************************************************************************
The Log:

Results folder: C:\Users\dprusins\AppData\Local\Temp\JMP_SAS_Results\Submit_1017