***********************************************************
***********************************************************
*****Working with Chris Fiore******************************
***********************************************************
***********************************************************

For this assignment we will perform an Exploratory Data Analysis 
(EDA) for a binary response variable and fit a single variable 
logistic regression model to the credit_approval data set using PROC LOGISTIC.


Part 1: The Exploratory Data Analysis: 

First, define the response variable Y=1 if A16=’+’ and Y=0 if A16=’-‘. 
The response variable will need to be defined in a SAS Data Step where 
you define a SAS data set named ‘temp’ (see the IF-THEN/ELSE statement pp. 
88-89 in The Little SAS Book). 

Second, prepare the data to perform an EDA by examining the distributions 
of attribute variables for each class. All of the data coding (the dummy 
variables and the discretization of the continuous variables) 
outlined below should be performed in a single SAS data step.

	*****Defining the Response Variable****;
*****Statement to access where the data is stored*****;
libname mydata '/courses/u_northwestern.edu1/i_833463/c_3505/SAS_Data/';
ods graphics on;

	
data temp;
	set mydata.credit_approval;
	if (A16='+') then Y =1;
	else Y=0;
	
	*****(1) The first step of the EDA is to look at the distributions 
	of the predictor variables using PROC MEANS with a CLASS statement 
	for the continuous predictor variables and PROC FREQ for the categorical 
	predictor variables. This step serves as a data check so that you can 
	view the possible values taken by categorical variables and the quantiles 
	of thecontinuous variables.*****; 
	
	proc freq data=temp;
tables A1 A4 A5 A6 A7 A9 A10 A12 A13 A16;
run; 

proc means data=temp p5 p10 p25 p50 p75 p90 p95;
class Y; 
var A2 A3 A8 A11 A14 A15;
	
	*****(2) Use the summary statistics from PROC MEANS to discretize the 
	continuous predictor variables using an IF-THEN/ELSE-IF/ELSE ladder 
	for each attribute.*****;
	
data temp;
	set mydata.credit_approval;
	if (A16='+') then Y =1;
	else Y=0;
	
	if (A2 < 24) then A2_discrete=1;
	else if (A2 < 31) then A2_discrete=2;
	else if (A2 < 42) then A2_discrete=3;
	else if (A2 < 53) then A2_discrete=4;
	else if (A2 < 59) then A2_discrete=5;
	else A2_discrete=6;
	
	if (A3 < 1.6) then A3_discrete=1;
	else if (A3 < 4.5) then A3_discrete=2;
	else if (A3 < 9.6) then A3_discrete=3;
	else if (A3 < 12) then A3_discrete=4;
	else if (A3 < 15) then A3_discrete=5;
	else A3_discrete=6;
	
	if (A8 < .45) then A8_discrete=1;
	else if (A8 < 1) then A8_discrete=2;
	else if (A8 < 3) then A8_discrete=3;
	else if (A8 < 5) then A8_discrete=4;
	else if (A8 < 10) then A8_discrete=5;
	else A8_discrete=6;
	
	if (A11 < .5) then A11_discrete=1;
	else if (A11 < 1.5) then A11_discrete=2;
	else if (A11 < 3) then A11_discrete=3;
	else if (A11 < 6) then A11_discrete=4;
	else if (A11 < 9) then A11_discrete=5;
	else A11_discrete=6;
	
	if (A14 < 101) then A14_discrete=1;
	else if (A14 < 170) then A14_discrete=2;
	else if (A14 < 281) then A14_discrete=3;
	else if (A14 < 400) then A14_discrete=4;
	else if (A14 < 471) then A14_discrete=5;
	else A14_discrete=6;
	
	if (A15 < 1.5) then A15_discrete=1;
	else if (A15 < 50) then A15_discrete=2;
	else if (A15 < 100) then A15_discrete=3;
	else if (A15 < 200) then A15_discrete=4;
	else if (A15 < 4000) then A15_discrete=5;
	else A15_discrete=6;
	
	*****(3) Code each categorical attribute using a family of dummy 
	variables (see SAS Statistics By Example pp. 153-155 and recall 
	that a categorical variable with k categories requires 
	(k-1) dummy variables). If an attribute has fifteen categories, 
	then you need to explicitly code fourteen dummy variables. The dummy 
	variables should be constructed in the following format.*****;
	
	if (A1='a') then A1_a=1; else A1_a=0;
	
	if (A4='l') then A4_a=1; 
	else if (A4='u') then A4_a=2; 
	else A4_a=0;
	
	if (A5='g') then A5_a=1; 
	else if (A5='gg') then A5_a=2; 
	else A5_a=0;
	
	if (A6='aa') then A6_a=1; 
	else if (A6='c') then A6_a=2;
	else if (A6='cc') then A6_a=3;
	else if (A6='d') then A6_a=4;
	else if (A6='e') then A6_a=5;
	else if (A6='ff') then A6_a=6;
	else if (A6='i') then A6_a=7;
	else if (A6='j') then A6_a=8;
	else if (A6='k') then A6_a=9;
	else if (A6='m') then A6_a=10;
	else if (A6='q') then A6_a=11;
	else if (A6='r') then A6_a=12; 
	else if (A6='w') then A6_a=13; 
	else A6_a=0;
	
	if (A7='bb') then A7_a=1; 
	else if (A7='dd') then A7_a=2;
	else if (A7='ff') then A7_a=3;
	else if (A7='h') then A7_a=4;
	else if (A7='j') then A7_a=5;
	else if (A7='n') then A7_a=6;
	else if (A7='o') then A7_a=7;
	else if (A7='v') then A7_a=8;
	else A7_a=0;
	
	if (A9='f') then A9_a=1; else A9_a=0;
	
	if (A10='f') then A10_a=1; else A10_a=0;
	
	if (A12='f') then A12_a=1; else A12_a=0;
	
	if (A13='g') then A13_a=1; 
	else if (A13='p') then A13_a=2;
	else A13_a=0;
	
	*****(4) Write a single IF statement at the bottom of your data 
	step to purge any missing values in any of the fifteen attributes. 
	(Hint: What values do the missing categorical variables take and what 
	values do the missing continuous variables take?)*****;
		
	if A1 = '?' then delete;
	else if A2 = '.' then delete;
	else if A3 = '.' then delete;
	else if A4 = '?' then delete;
	else if A5 = '?' then delete;
	else if A6 = '?' then delete;
	else if A7 = '?' then delete;
	else if A8 = '.' then delete;
	else if A9 = '?' then delete;
	else if A10 = '?' then delete;
	else if A11 = '.' then delete;
	else if A12 = '?' then delete;
	else if A13 = '?' then delete;
	else if A14 = '.' then delete;
	else if A15 = '.' then delete;
	
	*****(5) Use a PROC MEANS statement with a class statement to assess the
	predictive accuracy of an attribute. Here is a macro function to help you 
	perform the task. Note that the input variable needs to be a categorical 
	variable, hence this macro will also work for your discretized continuous 
	variables.
	
	%macro class_mean(c):
	proc means data=temp mean:
	*class A1 A4 A5 A6 A7 A9 A10 A12 A13:
	class &c. :
	var Y:
	run:
	%mend class_mean:*****;

	*****This is the Macro for finding the means*****;

%macro class_mean(c);
proc means data=temp mean;
	class &c. ;
	var Y;
Run; 
%mend class_mean; 

%class_mean (c=A1_a); 
%class_mean (c=A2_discrete);
%class_mean (c=A3_discrete);
%class_mean (c=A4_a);
%class_mean (c=A5_a);
%class_mean (c=A6_a);
%class_mean (c=A7_a);
%class_mean (c=A8_discrete); 
%class_mean (c=A9_a);
%class_mean (c=A10_a);
%class_mean (c=A11_discrete);
%class_mean (c=A12_a);
%class_mean (c=A13_a); 
%class_mean (c=A14_discrete);   
%class_mean (c=A15_discrete);

*****Part 2: Model Building: First, select the single variable logistic regression
model of your choice based on the EDA that you performed and fit the model. Second,
find the best single variable logistic regression model using the selection=score
option in PROC LOGISTIC with start=1 and stop=1. For this model you will include the 
continuous attributes as continuous predictor variables and the categorical attributes 
using your dummy variables. Note that you will have to use the descending option in 
PROC LOGISTIC, see Chapter 11 of SAS Statistics By Example. In your discussion be sure 
to answer the following discussion questions.
	(1) Did you select the optimal regression model using EDA?
	(2) How do we interpret the estimated coefficient for a dummy variable?
	(3) What does it mean when a dummy variable is dropped from the model?*****;


title "Logistic Regression with One Categorical Predictor Variable LRUS p35";
proc logistic data=temp;
	class A11_discrete (param=ref ref='1');  
	model Y (event= '1') = A11_discrete /; 
	estimate 'coeff for 1' A11_discrete -1 -1 -1 -1 -1;
run;  

proc logistic data=temp des;
	class A1_a A4_a A5_a A6_a A7_a A9_a A10_a A12_a A13_a;
	model Y = A1_a A2 A3 A4_a A5_a A6_a A7_a A8 A9_a A10_a A11 A12_a A13_a A14 A15/
	stb start=1 stop=1;
	run;  
	