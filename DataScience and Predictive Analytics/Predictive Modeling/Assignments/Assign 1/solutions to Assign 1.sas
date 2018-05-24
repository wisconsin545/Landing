/* 	Chad R. Bhatti
	04.13.2012
	student_solution1.sas
*/


libname mydata 	'/courses/u_northwestern.edu1/i_833463/c_3505/SAS_Data/' access=readonly; 

/*
proc contents data=mydata.building_prices; run; quit;
proc print data=mydata.building_prices(obs=5); run; quit;
*/

data temp;
	set mydata.building_prices;
run;


* Produce the scatterplot matrix;
ods graphics on;
proc corr data=temp plot=matrix(histogram nvar=all); 
run;
ods graphics off;


* Produce LOESS scatterplot smoothers in panels of three;
ods graphics on;
proc sgscatter data=temp;
compare x=(x1 - x3)
		y=Y / loess; 
run; quit;
ods graphics off;


ods graphics on;
proc sgscatter data=temp;
compare x=(x4 - x6)
		y=Y / loess; 
run; quit;

proc sgscatter data=temp;
compare x=(x7 - x9)
		y=Y / loess; 
run; quit;
ods graphics off;


**************************************************************************;
* Alternate method of making scatterplots using PROC GPLOT;
* Note that I have created a "macro function" named %myplot()
which has a "macro variable" x as an argument.;

%macro myplot(x);
proc gplot data=temp;
plot Y*&x.;
run;
%mend myplot;


%myplot(x=x1);
%myplot(x=x2);
%myplot(x=x3);
%myplot(x=x4);
%myplot(x=x5);
%myplot(x=x6);
%myplot(x=x7);
%myplot(x=x8);
%myplot(x=x9);


/*************************************************************************
Comments:
**************************************************************************
(1) Correlations with Y
X1(0.8791) X2(0.70978) X3(0.64764) X4(0.70777) X5(0.46147) X6(0.52844)
X7(0.28152) X8(-0.39740) X9(0.26688)


Clearly X1 has the largest correlation, but is it still the best variable
to use as a predictor in a simple linear regression model?  What other
criterion should we consider?  Correlation is a measure of the strength
of the linear relationship between X and Y, WHEN there is a linear relationship.
When the relationship is not linear, correlation is not a measure of the
linear relationship.  It is simply a number.  See the discussion of Anscombe's 
Quartet in the book.  The correlation coefficient for X1 is a vaild measure
of the strength of the linear relationship because X1 does have a linear
relationship with Y.  When viewing a scatterplot, we want our scatterplot to
be an ellipse.


Now consider the variables X2, X3, and X4.  Which one of these three variables
would be the single best predictor?  The choice should be between X3 and X4.
Why do we eliminate X2?  Between X3 and X4, as is we would take X4, unless we
want to remove the outlier in X3.


What about when a predictor variable takes only a small number of values,
such as X2?  Should we consider X2 to be a continuous variable or a categorical
variable?  In practice we should consider X2 to be categorical and code it using
dummy variables.  How would we do this?


Why do we look at the LOESS scatterplot smoothers?  Remember that the correlation
coefficient is only a valid measure of the strenght of the linear relationship 
when a linear relationship is present.  We examined the scatterplots using a 
scatterplot matrix in order to visualize the existence of a linear relationship.
A scatterplot smoother provides us with a "smoothed" estimate of the shape of the
relationship between the two variables.  The scatterplot smoother is a common
tool for visualizing statistical relationships.  If the LOESS relationship is 
approximately linear, then we can trust that the relationship is linear.


*************************************************************************/




















