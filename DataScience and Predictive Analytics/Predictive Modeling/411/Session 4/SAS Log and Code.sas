*****SAS LOG*****;
The SAS Workspace Server connection to "SASApp" has been lost.
Results folder: C:\Users\dprusins\AppData\Local\Temp\JMP_SAS_Results\Submit_1168;

*****SAS Code*****; 

/*  Define the library names */
libname mydata56 "/courses/u_northwestern.edu1/i_829657/c_4884" access=readonly;

/*  Create temporary data sets to mess with */
Data week4;
	set mydata56.airlines_week_4;
	LnC=log(C);
	LnQ=Log(Q);
	LnPF=Log(PF);
Run;

*****Random Effects Modeling***;
/*  This is the program on page 130 and produces Output 7.12 */
Proc Panel data=week4;
	id i t;
	model LnC=LnQ LnPF LF/ranone bp;
run;

/*  This is the program on page 131 and produces Output 7.13 */
Proc Panel data=week4;
	id i t;
	model LnC=LnQ LnPF LF/rantwo;
run;


/*  The following programs are given on page 123 and produce Outputs 7.7--7.9 */
proc glm data=week4;
	class t;
	model LnC=t LnQ LnPF LF/solution;
run;
proc panel data=week4;
	id i t;
	model LnC=LnQ LnPF LF/fixtwo;
run;
proc glm data=week4;
	class i;
	model LnC=i t LnQ LnPF LF/solution;
run;


/*  The following program is given on page 121 and produces Output 7.6 */
proc panel data=week4;
	id i t;
	model LnC=LnQ LnPF LF/fixonetime;
run;

/*  LSDV Model pages 114 to the top of 116 and produces Output 7.2 */
proc iml;
	use week4;
	read all var{'lnq','lnpf','lf'} into X;
	read all var{'lnc'} into y;
	T=15;N=6;k=ncol(X);
	i=J(T,1,1);
	NT=nrow(X);
	D=block(i,i,i,i,i,i);
	I=I(NT);
	MD=I-D*inv(D`*D)*D`;
	b_LSDV=inv(X`*MD*X)*X`*MD*y;
	a=inv(D`*D)*D`*(y-X*b_LSDV);
	sigma2=(MD*y-MD*X*b_LSDV)`*(MD*y-MD*X*b_LSDV)/(NT-N-K);
	Var_B=sqrt(vecdiag(sigma2*inv(X`*MD*X)));
	summary var {lnq lnpf lf} class {i} stat{mean} opt{save};
	X_Mean=LNQ||LNPF||LF;
	Var_A=Vecdiag(SQRT(sigma2/T + X_mean*sigma2*inv(X`*MD*X)*X_Mean`));
	print 'The LSDV estimates are';
	Table1=b_LSDV||Var_B;
	Table2=a||Var_A;
	Print Table1 (|Colname={Beta_LSDV SE} rowname={LNQ LNPF LF} format=8.4|);
	Print Table2 (|Colname={ALPHA SE} rowname={Alpha1 Alpha2 Alpha3 Alpha4 Alpha5 Alpha6} format=8.4|);
run;

/*  This is the program given on the top of page 118 and produces Output 7.4 */
Proc Panel data=week4;
	id i t;
	model LnC=LnQ LnPF LF/fixone;
run;

/*  This is the program at the bottom of page 118 and produces Output 7.5 */
Proc GLM data=week4;
	class i;
	model LnC=i LnQ LnPF LF/solution;
run;

/*  This is the program for the pooled regression model with OLS*/ 
proc reg data=week4;
	model LnC=LnQ LnPF LF;
run;

***** This is helpful for looking at the airlines and time*****;
proc freq data=week4;
tables i t;
run;

/*  Run Proc Contents and a Test Print */
Proc Contents data=week4;
Run;
Proc Print data=week4 (obs=20);
Run;