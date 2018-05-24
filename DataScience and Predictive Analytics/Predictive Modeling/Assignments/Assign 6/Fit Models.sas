*Daniel Prusinski Assignment 6 Version 1.1******************
*Fit Models*************************************************
***********************************************************;

*****Statement to access where the data is stored*****;
libname mydata '/courses/u_northwestern.edu1/i_833463/c_3505/SAS_Data/';
ods graphics on;

*****This creates the response variable*****;
data temp; 
	set mydata.credit_approval;
	
	u=uniform(123);
	if (u<0.7) then train=1; else train=0;
	
	if (A16='+') then Y =1;
	else Y=0;
	
	if (train=1) then Y_train=Y; else Y_train=.;


	*****Categorical Variables*****
	*******************************
	*******************************;
	
		
if (A1='a') then A1_a=1; else A1_a=0;
	
if (A4='u') then A4_u=1; else A4_u=0;

if (A5='g') then A5_g=1; else A5_g=0;
	
if (A6='aa') then A6_aa=1; else A6_aa=0; 
if (A6='c') then A6_c=1; else A6_c=0; 
if (A6='cc') then A6_cc=1; else A6_cc=0;
if (A6='d') then A6_d=1; else A6_d=0;
if (A6='e') then A6_e=1; else A6_e=0;
if (A6='ff') then A6_ff=1; else A6_ff=0;
if (A6='i') then A6_i=1; else A6_i=0;
if (A6='j') then A6_j=1; else A6_j=0;
if (A6='k') then A6_k=1; else A6_k=0;
if (A6='m') then A6_m=1; else A6_m=0;
if (A6='q') then A6_q=1; else A6_q=0;
if (A6='r') then A6_r=1; else A6_r=0; 
if (A6='w') then A6_w=1; else A6_w=0;

*****I left off a few of the small variables, I want to see what this does*****;	
if (A7='bb') then A7_bb=1; else A7_bb=0; 
if (A7='ff') then A7_ff=1; else A7_ff=0;
if (A7='h') then A7_h=1; else A7_h=0;
if (A7='v') then A7_v=1; else A7_v=0;

if (A9='t') then A9_t=1; else A9_t=0;
	
if (A10='t') then A10_t=1; else A10_t=0;
	
if (A12='t') then A12_t=1; else A12_t=0;
	
if (A13='g') then A13_g=1; else A13=_g=0;
	
*****This purges the Data, 90 LSB*****;
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
run;

proc freq data=temp;
tables Y;
run;

proc freq data=temp;
tables train;
run;

proc logistic data=temp descending;
model Y_train = A2 A3 A8 A11 A15
	A1_a A4_u A5_g A6_k A6_q A6_w A7_bb A7_ff A7_h A7_v 
	A9_t A10_t A12_t A13_g / selection=backward;
output out=model_data pred=yhat;
run; 

proc logistic data=temp descending;
model Y_train = A9_t A2 A3;
output out=model_data2 pred=yhat;
run; 

