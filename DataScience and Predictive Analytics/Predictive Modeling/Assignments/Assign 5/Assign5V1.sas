*Daniel Prusinski Assignment 5 Version 1********************
************************************************************
***********************************************************;

*****Statement to access where the data is stored*****;
libname mydata '/courses/u_northwestern.edu1/i_833463/c_3505/SAS_Data/';
ods graphics on;

*****Let's have a look at the data*****;
proc print data=mydata.credit_approval;
run;

*****Let's take a look at the Metadata*****;
proc contents data=mydata.credit_approval;
run;


*****Setting the Temp Data*****;
data temp;
	set mydata.credit_approval;
	if (A16='+') then Y =1;
	else Y=0;
run;

proc freq data=temp;
tables A1 A4 A5 A6 A7 A9 A10 A12 A13 A16;
run; 

proc means data=temp p5 p10 p25 p50 p75 p90 p95;
class Y; 
var A2 A3 A8 A11 A14 A15;
run; 

	*****Discrete Variables*****
	****************************
	****************************;
data temp;
	set mydata.credit_approval;
	if (A16='+') then Y =1;
	else Y=0;
	
	if (A15 < 1.5) then A15_discrete=1;
	else if (A15 < 50) then A15_discrete=2;
	else if (A15 < 100) then A15_discrete=3;
	else if (A15 < 200) then A15_discrete=4;
	else if (A15 < 4000) then A15_discrete=5;
	else A15_discrete=6;
	
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
	
	if (A8 < 1) then A8_discrete=2;
	else if (A8 < 3) then A8_discrete=3;
	else if (A8 < 5) then A8_discrete=4;
	else A8_discrete=6;
	
	if (A11 < .5) then A11_discrete=1;
	else if (A11 < 1.5) then A11_discrete=2;
	else if (A11 < 3) then A11_discrete=3;
	else A11_discrete=4;
		
	if (A6_a < 1) then A6_discrete=1;
	else if (A6_a < 1.5) then A6_discrete=2;
	else if (A6_a < 2) then A6_discrete=3;
	else if (A6_a < 6) then A6_discrete=4;
	else if (A6_a < 9) then A6_discrete=5;
	else if (A6_a < 11) then A6_discrete=6;
	else A6_discrete=7;
	
	if (A14 < 101) then A14_discrete=1;
	else if (A14 < 170) then A14_discrete=2;
	else if (A14 < 281) then A14_discrete=3;
	else if (A14 < 400) then A14_discrete=4;
	else if (A14 < 471) then A14_discrete=5;
	else A14_discrete=6;
	
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
	
proc freq data=temp;
tables A1 A1_a A4 A4_a A5 A5_a A6 A6_a A7 A7_a A9 A9_a A10 A10_a A12 A12_a A13 A13_a A16;
run;
	
	
	
run; 

proc freq data=temp;
tables A1 A2_discrete A3_discrete A4 A5 A6 A7 A8_discrete A9 A10 A11_Discrete A12 A13 A14_discrete A15_discrete A16;
run; 

***** I did this to verify that the procedure worked on its own, and then to verify that the 
macro did the same thing - All the semi-colons are taken out and replaced with colons so you
can see the steps. 
proc means data=temp mean:
	class A1:
	var Y:
Run: 

%macro class_mean(c):
proc means data=temp mean:
	class &c. :
	var Y:
Run: 
%mend class_mean: 

%class_mean (c=A1); 
*****;  

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
%class_mean (c=A4_u);
%class_mean (c=A5_g);

%class_mean (c=A6_aa);
%class_mean (c=A6_c);
%class_mean (c=A6_cc);
%class_mean (c=A6_d);
%class_mean (c=A6_e);
%class_mean (c=A6_ff);
%class_mean (c=A6_i);
%class_mean (c=A6_j);
%class_mean (c=A6_k);
%class_mean (c=A6_m);
%class_mean (c=A6_q);
%class_mean (c=A6_r);
%class_mean (c=A6_w);

%class_mean (c=A7_bb);
%class_mean (c=A7_ff);
%class_mean (c=A7_h);
%class_mean (c=A7_v);

%class_mean (c=A8_discrete); 
%class_mean (c=A9_t);
%class_mean (c=A10_t);
%class_mean (c=A11_discrete);
%class_mean (c=A12_t);
%class_mean (c=A13_g); 
%class_mean (c=A14_discrete);   
%class_mean (c=A15_discrete);



title "Logistic Regression with One Categorical Predictor Variable LRUS p35";
proc logistic data=temp;
	class A11_discrete (param=ref ref='1');  
	model Y (event= '1') = A11_discrete /; 
run;  

proc logistic data =temp descending;
model Y (event ='1') = A1_a A2 A3 A4_u A5_g A6_k A6_m A6_q A6_w A7_bb A7_ff A7_h A7_v 
	A8 A9_t A10_t A11 A12_t	A13_g A14 A15 / selection=score start=1 stop=1;
run;

proc logistic data =temp;
	class A9_t (param=ref ref='0'); 
model Y (event ='1') = A9_t /;
run;


proc logistic data=temp descending plots(only)=roc(id=prob);
model Y = A9_t / outroc=roc1; 
run;

proc logistic data=temp descending plots(only)=roc(id=prob);
model Y = A9_t A11 / outroc=roc1; 
run;
proc print data=roc1; 
run




