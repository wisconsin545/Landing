/* 	Chad R. Bhatti
	11.04.2012
	solution5.sas
*/


libname mydata 	'/courses/u_northwestern.edu1/i_833463/c_3505/SAS_Data/' access=readonly; 

proc contents data=mydata.credit_approval; run; quit;
proc print data=mydata.credit_approval(obs=5); run; quit;

* Turn off ods graphics;
ods graphic off;


* Create the response variable Y and dummy variables for the categorical predictor
variables;
data temp;
	set mydata.credit_approval;
	
	if A16='+' then Y=1; 
	else if A16='-' then Y=0;
	else Y=.;
	
	* We need to define our dummy variables and have K-1 variables. This is
because the model will have an intercept. Allow the smallest categories to be the
base and use the bigger variables as the categories. This way the intercept is not that 
important. 
Discritize Variables: Look at your conditional distributions. 
You want to make cuts that have high discimination in either direction. You don't 
want values near .5, becuase that means nothing.  
	
	
	
	A1 Base category is A1='a';
	if (A1='b') then A1_b=1; else A1_b=0;
	* A4 Base category is: l,y;
	if (A4='u') then A4_u=1; else A4_u=0;
	* A5 Base caetgory is: gg,p;
	if (A5='g') then A5_g=1; else A5_g=0;
	
	* These dummy variables for A6 are somewhat arbitrary;
	* I have done this on purpose for discussion purposes;
	* Note that I have lumped some small categories into the base category;
	* A6 takes 14 values;
	* A6 Base category is: d,e,j,r;
	if (A6='aa') then A6_aa=1; else A6_aa=0;
	if (A6='c')  then A6_c=1; else A6_c=0;
	if (A6='cc') then A6_cc=1; else A6_cc=0;
	if (A6='ff') then A6_ff=1; else A6_ff=0;
	if (A6='i')  then A6_i=1; else A6_i=0;
	if (A6='k')  then A6_k=1; else A6_k=0;
	if (A6='m')  then A6_m=1; else A6_m=0;
	if (A6='q')  then A6_q=1; else A6_q=0;
	if (A6='w')  then A6_w=1; else A6_w=0;
	if (A6='x')  then A6_x=1; else A6_x=0;
	
	* A7 Base category is: dd,j,n,o,z;
	if (A7='bb') then A7_bb=1; else A7_bb=0;
	if (A7='ff') then A7_ff=1; else A7_ff=0;
	if (A7='h')  then A7_h=1; else A7_h=0;
	if (A7='v')  then A7_v=1; else A7_v=0;
	
	if (A9='t')  then A9_t=1; else A9_t=0;
	if (A10='t') then A10_t=1; else A10_t=0;
	if (A12='t') then A12_t=1; else A12_t=0;
	
	* A13 Base category is: p,s;
	if (A13='g') then A13_g=1; else A13_g=0;
	
	
	*****************************************************************;
	* Discretize the continuous variables for EDA;
	*****************************************************************;
	* I will include the continuous variables into the model as
	continuous variables.  If you want to include them in the model
	as discrete variables, then you would need to create a family of 
	dummy variables for each of these discretizations.;
	if (A2 < 20) then A2_discrete=1;
	else if (A2 < 25) then A2_discrete=2;
	else if (A2 < 35) then A2_discrete=3;
	else if (A2 < 45) then A2_discrete=4;
	else A2_discrete=5;

	if (A3 < 1) then A3_discrete=1;
	else if (A3 < 2) then A3_discrete=2;
	else if (A3 < 5) then A3_discrete=3;
	else if (A3 < 10) then A3_discrete=4;
	else A3_discrete=5;
	
	if (A8 < 0.5) then A8_discrete=1;
	else if (A8 < 1) then A8_discrete=2;
	else if (A8 < 2) then A8_discrete=3;
	else if (A8 < 5) then A8_discrete=4;
	else if (A8 < 10) then A8_discrete=5;
	else A8_discrete=6;
	
	if (A11 < 1) then A11_discrete=1;
	else if (A11 < 3.01) then A11_discrete=2;
	else A11_discrete=3;

	if (A14 < 100) then A14_discrete=1;
	else if (A14 < 150) then A14_discrete=2;
	else if (A14 < 250) then A14_discrete=3;
	else if (A14 < 350) then A14_discrete=4;
	else A14_discrete=5;

	if (A15 < 1.5) then A15_discrete=1;
	else if (A15 < 50) then A15_discrete=2;
	else if (A15 < 100) then A15_discrete=3;
	else if (A15 < 200) then A15_discrete=4;
	else if (A15 < 4000) then A15_discrete=5;
	else A15_discrete=6;
	
	* Define two dummy variables for continuous variables;
	* These are for example purposes;	
	if (A15 < 200) then A15_dummy=0; else A15_dummy=1;
	if (A11 < 1) then A11_dummy=0; else A11_dummy=1;
	
	* Delete the observations with missing values;
	if (A1='?') or (A4='?') or (A5='?') or (A6='?') or (A7='?') 
	or (A2=.) or (A3=.) or (A8=.) or (A11=.) or (A14=.) or (A15=.)
	then delete;
	
run;

proc freq data=temp;
tables A1 A4 A5 A6 A7 A9 A10 A12 A13 A16;
run;

proc means data=temp p5 p10 p25 p50 p75 p90 p95;
class Y;
var A2 A3 A8 A11 A14 A15;
run;




/*********************************************************************************;
If we were only interested in data quality, then we could simply perform EDA on
the predictor variables by themselves.  However, we are interested in building a
predictive model, so we want to perform an EDA with respect to the response rate
for each predictor variable. 

When we compute the mean of a 0/1 variable, we are computing the percentage of 
each class that is a 1.  If you look at A9, then you will see that 78.77 percent
of the observations with A9='t' have Y=1 and only 5.75 percent of the observations
with A9='f' have Y=1.  This indicates that A9 is highly predictive of Y.  We can
also see this in the PROC FREQ cross tab.
*********************************************************************************/;

%macro class_mean(c);
proc means data=temp mean;
*class A1 A4 A5 A6 A7 A9 A10 A12 A13;
class &c. ;
var Y;
run;
%mend class_mean;

* Categorical variables;
%class_mean(c=A1);
%class_mean(c=A4);
%class_mean(c=A5);
%class_mean(c=A6);
%class_mean(c=A7);
%class_mean(c=A9);
%class_mean(c=A10);
%class_mean(c=A12);
%class_mean(c=A13);

* Note that A9 is very effective at classifying;
* PROC FREQ crosstab;
proc freq data=temp;
tables A9*Y;
run;

*Discretized continuous variables;
%class_mean(c=A2_discrete);
%class_mean(c=A3_discrete);
%class_mean(c=A8_discrete);
%class_mean(c=A11_discrete);
%class_mean(c=A14_discrete);
%class_mean(c=A15_discrete);


/* 	Note that A15 (with cut at 200) and A11 (with cut at 1) are both effective at 
	classifying Y.

	For A15_dummy 67.19% of observations with A15_dummy=0 have Y=0, and 71.56% of
	observations with A15_dummy=1 have Y=1.
	
	For A11_dummy 74.59% of observations with A11_dummy=0 have Y=0, and 70.73% of
	observations with A11_dummy=1 have Y=1.
*/
proc freq data=temp;
tables A15_dummy*Y;
run;

proc freq data=temp;
tables A11_dummy*Y;
run;


/*  If you want to use variable selection with categorical variables in PROC LOGISTIC,
	then you need to code all of the categorical variables into dummy variables by hand.
	If you let SAS define the dummy variables using a CLASS statement, then you cannnot
	use variable selection.  Remember that a dummy variable is a standard concept that 
	is valid in any type of regression model.  A dummy variable is a transformation of a
	predictor variable, and it is interpreted as an intercept adjustment.
*/

	
	
proc logistic data=temp descending;
model Y = A2 A3 A8 A11 A14 A15
	/* A11_dummy A15_dummy */
	A1_b A4_u A5_g 
	A6_aa A6_c A6_cc A6_ff A6_i A6_k A6_m A6_q A6_w A6_x 
	A7_bb A7_ff A7_h A7_v
	A9_t A10_t A12_t A13_g / selection=score start=1 stop=1;
run;

/*  Consider the dummy variables: A6_aa,A6_c,A6_cc,A6_ff,A6_i,A6_k,A6_m,A6_q,A6_w,A6_x.
	The base category of the family of A6 dummy variables contains the values {d,e,j,r}.
	If the variable selection drops the variable A6_aa, then the model is saying that
	there is no difference between the value {aa} and the values {d,e,j,r}.  Once A6_aa
	is dropped, then the base category becomes {aa,d,e,j,r}.  This interpretation holds
	with respect to the base category for all of the dropped dummy variables. 

*/

/*	Definition of SAS Output Statistics for Logistic Regression

	These statistics are defined and explained in "Logistic Regression Using SAS"
	by Allison in pages 68-71.  The measures Tau, Gamma, and Somer's D are based
	on pairwise comparisons of an observation with (Y=0) and an observation with
	(Y=1).  In each pairwise comparison we are interested in knowing if the (Y=1) 
	observation has a higher "score" (y-hat value) than the (Y=0) observation.  If
	this statement is true, then the pair is said to be "concordant" (C).  If this 
	statement is false, then the pair is said to be "discordant" (D).  If the two 
	observations have the same score, then they are said to be tied (T).
	High is always better.
	
	(1) Tau-a = (C-D)/N
	(2) Gamma = (C-D)/(C+D)
	(3) Somer's D = (C-D)/(C+D+T)
	(4) c = 0.5*(1 + Somer's D)

	All four measures take values in [0,1] with larger values representing better fits.
	
*/


/*	The Receiver Operating Characteristic Curve is covered in Allison pp. 72-77. 
	Notice that c = 0.5*(1 + Somer's D) is the Area Under the ROC Curve (frequently
	denoted by AUC).  
	
	Sensitivity = the True Positive Rate
	Specificity = the True Negative Rate
	1 - Specificity = the False Positive Rate
	
	We want a high sensitivity and a low (1-Specificity).  ROC curves with higher 
	values for the AUC satisfy this requirement when comparing two scoring 
	classifiers.  (Do we understand why this is true?)
	
	 
*/



* Make ROC curve with cut-points;
ods graphics on;
proc logistic data=temp descending plots(only)=roc(id=prob);
model Y = A9_t / outroc=roc1;
run;
ods graphics off;

proc print data=roc1; run;quit;

ods graphics on;
proc logistic data=temp descending;
model Y = A9_t A11;
run;

/*	By looking at the output data set we see that the cut-point 0.8 has a
	Sensitivity=0.93919 and a 1-Specificity=0.19888.
	
	The second cut point of 0.6 has a Sensitivity=1.000 and a 1-Specificity=1.000.
	This is a garbage cut-point.  If you choose this cut-off value you will correctly
	classify all of the (Y=1) observations, but you also misclassify all of the (Y=0)
	values.
*/


* Compare ROC curves for two models;
ods graphics on;
proc logistic data=temp descending;
model Y = A9_t A11;
ROC 'omit A11' A9_t;
ROCCONTRAST / ESTIMATE=ALLPAIRS;
run;
ods graphics off;

/* 	The model with both A9_t and A11 is better than the model with only A9_t.
	You can arrive at this conclusion by looking at the AUC 0.9126 > 0.8702.
*/






