/*  This is an example of weighted least squares */
/*  If you regress resp against vel and vol (velocity and volume) you will encounter heteroscedasticity */
/*  The variance of the 4 cells/combinations are different */
data test;
	input vel vol resp;
	cards;
	60 50 87.5
	60 50 88.2
	60 50 88.1
	60 50 87.3
	60 50 89.5
	60 50 89.2
	60 50 86.2
	60 50 85.9
	60 50 90
	60 50 87
	60 70 77.4
	60 70 68.1
	60 70 70.7
	60 70 65.3
	60 70 67
	60 70 61
	60 70 71.7
	60 70 81.7
	60 70 79.2
	60 70 60.3
	120 50 82.5
	120 50 81.3
	120 50 81.6
	120 50 80.7
	120 50 77.4
	120 50 79.3
	120 50 81.5
	120 50 82
	120 50 79.7
	120 50 79.2
	120 70 61.2
	120 70 50.7
	120 70 67.2
	120 70 52.3
	120 70 55.9
	120 70 68.6
	120 70 52
	120 70 69.5
	120 70 63.5
	120 70 70.1
;
/*  Here, I sort the data by vel and vol and calculate the variances for the 4 combinations */
proc sort data=test;
	by vel vol;
run;
proc univariate data=test noprint;
	var resp;
	by vel vol;
	output out=var n=n var=var;
run;
proc print data=var;
run;
/*  Here, I create the weights for each observation */
data test;
	set test;
	if vel=60 and vol=50 then w=1/1.8899;
	else if vel=60 and vol=70 then w=1/54.3204;
	else if vel=120 and vol=50 then w=1/2.5018;
	else w=1/60.6933;
run;
/*  Here, I simply run an OLS using the weights */
proc reg data=test;
	model resp=vel vol;
	weight w;
run;

/*  This is a dose response example */
/*  Dose is the dose;  n is the number of subjects;  x=number of subjects effected */
/*  The first part does an OLS on the Log Odds using the weights defined by the variance of a binomial distribution n*p*(1-p) */
/*  The second does a logistic regression on the data */
data dose;
	input dose n x;
	cards;
	0 600 15
	30 500 96
	60 600 187
	75 300 100
	90 300 145
;
data dose;
	set dose;
	p=x/n;
	w=n*p*(1-p) /*  The weights */;
	resp=log(p/(1-p)) /* The response for the OLS--Log of odds */;
run;
proc reg data=dose;
	model resp=dose;
	weight w;
run;
proc logistic data=dose;
	model x/n=dose;
run;
