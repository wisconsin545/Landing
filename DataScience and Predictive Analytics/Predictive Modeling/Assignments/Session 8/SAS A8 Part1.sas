**********************************************
Assignment 8 Version1
Daniel Prusinski
11/25/2012
**********************************************;

*****Part 1: An Initial Correlation Analysis*****;

libname mydata 	'/courses/u_northwestern.edu1/i_833463/c_3505/SAS_Data/' access=readonly; 
title ;

proc contents data=mydata.factor_data; run; quit;
proc print data=mydata.factor_data (obs=5); run; quit;

data temp; 
	set mydata.factor_data;


*****I am still working on the macro, 
but at least the correlation matrix is done*****;

%macro corr_matrix (k);

proc corr data=temp plots=matrix;
var x&k._1 x&k._2 x&k._3;
with z&k.;
run;

%mend corr_matrix;

%corr_matrix(k=1);
%corr_matrix(k=2);
%corr_matrix(k=3);
%corr_matrix(k=4);
%corr_matrix(k=5);
*****************
*****Part 2******
*****************;

proc standard data=temp mean=0 std=1 out=temp_std;
var z1 z2 z3 z4 z5
	x1_1 x1_2 x1_3
	x2_1 x2_2 x2_3
	x3_1 x3_2 x3_3
	x4_1 x4_2 x4_3
	x5_1 x5_2 x5_3 ;
run; 

data zdata;
	set temp_std;
	keep y z1 z2 z3 z4 z5;
run;

data xdata;
	set temp_std;
	drop y z1 z2 z3 z4 z5;
run;

ods graphics on;
proc princomp data=xdata out=xdata_pca outstat=pca_stats plots=(scree);
run;
ods graphics off: 

ods graphics on; proc princomp data=xdata out=xdata_pca outstat=pca_stats plots=(scree); run; ods graphics off;

*****************
*****Part 3******
*****************;

ods graphics on; 
proc factor data=xdata method=ml out=xdata_ml outstat=ml_stats 
mineigen=0 priors=max nfactors=15 score scree ; 
run; ods graphics off;

ods graphics on; proc factor data=xdata method=uls heywood out=xdata_uls 
outstat=uls_stats mineigen=0 priors=max nfactors=15 score scree ; 
run; ods graphics off;

*****************
*****Part 4******
*****************;

ods graphics on; 
proc factor data=xdata method=uls heywood out=xdata_uls outstat=uls_stats 
mineigen=0 priors=max nfactors=5 score scree ; 
run; ods graphics off;

ods graphics on; proc factor data=xdata method=uls heywood rotate=varimax 
out=xdata_varimax outstat=varimax_stats mineigen=0 
priors=max nfactors=5 score scree ; 
run; ods graphics off;

*****************
*****Part 5******
*****************;
proc corr data=xdata_pca; 
var prin1 prin2 prin3 prin4 prin5; 
run;

proc corr data=xdata_uls; 
var factor1 factor2 factor3 factor4 factor5; 
run;

proc corr data=xdata_varimax; 
var factor1 factor2 factor3 factor4 factor5; 
run;

*****************
*****Part 6******
*****************;

data pca_data; 
set xdata_pca (keep= prin1 prin2 prin3 prin4 prin5); 
id_nbr = _n_; 
run;

data varimax_data; 
set xdata_varimax (keep= factor1 factor2 factor3 factor4 factor5); 
id_nbr = _n_; 
run;

data zdata; 
set zdata; id_nbr = _n_; 
run;

proc sort data=pca_data; 
by id_nbr; run; 

proc sort data=varimax_data; 
by id_nbr; run; 

proc sort data=zdata; 
by id_nbr; run;

data model_data; 
retain id_nbr; 
merge zdata pca_data varimax_data; 
by id_nbr; run;

* True model; 
proc reg data=model_data; 
model Y = z1 z2 z3 z4 z5 / vif; 
run; quit;

* PCA model; proc reg data=model_data; 
model Y = prin1 prin2 prin3 prin4 prin5 / vif; 
run; quit;

proc reg data=model_data; 
model Y = factor1 factor2 factor3 factor4 factor5 / vif; 
run; quit;

proc reg data=temp; 
model Y = x1_1 x1_2 x1_3 
x2_1 x2_2 x2_3 
x3_1 x3_2 x3_3 
x4_1 x4_2 x4_3 
x5_1 x5_2 x5_3
 / selection=backward vif; 
 run; quit;