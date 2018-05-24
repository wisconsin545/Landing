/*  Upload the Excel file AC_Ex into JMP and then load it into the Work directory */
/*  Read the data set */
/*  Demand:  Annual Residential Electric Demand */
/*  Customers:  The number of residential customers */
/*  CDD:  The summer cooling degree days */
data ac_ex;
	set work.ac_ex;
run;
/*  Perform the usual quality checks */
proc contents data=ac_ex;
run;
proc print data=ac_ex;
run;
/*  Run an Autoreg with the dwprob option to get the DW statistic and associated probability */
proc autoreg data=ac_ex;
	model demand=customers cdd/dwprob;
run;
/*  Note that the DW test indicates the presence of first order autocorrelation */
/*  Let's iterate here by including the nlag=1 and Godfrey's options */
proc autoreg data=ac_ex;
	model demand=customers cdd/nlag=1 dwprob godfrey;
run;
/*  Both the DW and Godfrey's test indicates that a first order autocorrelation is significant */
/*  The value of the first order autocorrelation is 0.4409 */
/*  Let's do a generalized DW test for the first 4 autocorrelations---Also, include the Godfrey's option here */
proc autoreg data=ac_ex;
	model demand=customers cdd/dwprob dw=4 godfrey;
run;
/*  We see that the first order autocorrelation model is all we need to worry about here */
/*  Let's formally wrap this up */
proc autoreg data=ac_ex;
	model demand=customers cdd/nlag=1 dwprob godfrey;
run;
/*  Both the DW and the Godfrey's tests are now insignificant */
/*  The Yule Walker FGLS estimates are given to you at the bottom of the output */