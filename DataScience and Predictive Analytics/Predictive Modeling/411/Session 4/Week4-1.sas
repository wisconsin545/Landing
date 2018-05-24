/*  Define the library names */
LIBNAME mydata "/courses/u_northwestern.edu1/i_829657/c_4376" access=readonly;
/*  Create temporary data sets to mess with */
Data week4;
	set mydata.airlines_week_4;
	LnC=log(C);
	LnQ=Log(Q);
	LnPF=Log(PF);
Run;
/*  Run Proc Contents and a Test Print */
Proc Contents data=week4;
Run;
Proc Print data=week4 (obs=20);
Run;
/*  This is the program on page 112 and produces Output 7.1 */
proc reg data=week4;
	model LnC=LnQ LnPF LF;
run;

/*  This is the Proc IML code given on pages 114 to the top of 116 and produces Output 7.2 */
proc iml;
	use week2;
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

/*  This is the code given on page 116 and produces Output 7.3 */
proc iml;
	use week4;
	read all var{'lnq','lnpf','lf'} into X;
	read all var{'lnc'} into y;
	T=15;N=6;k=ncol(X);
	i=J(T,1,1);
	NT=nrow(X);
	D=block(i,i,i,i,i,i);
	I=I(NT);
	X=X||D;
	Delta_LSDV=inv(X`*X)*X`*y;
	sigma2=(y-X*Delta_LSDV)`*(y-X*Delta_LSDV)/(NT-N-K);
	Var_Delta=sqrt(vecdiag(sigma2*inv(X`*X)));
	Table1=Delta_LSDV||Var_Delta;
	Print Table1 (|Colname={LSDV_Estimates SE} rowname={LNQ LNPF LF Alpha1 Alpha2 Alpha3 Alpha4 Alpha5 Alpha6} format=8.4|);
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

/*  The following programs are given on page 120 */
proc sort data=week4;
	by i;
run;

proc univariate data=week4 noprint;
	var LnC LnQ LnPF LF;
	by i;
	output out=junk mean=meanc meanq meanpf meanlf;
run;

data test;
	merge week4(in=a) junk(in=b);
	by i;
	if a and b;
	lnc=lnc-meanc;
	lnq=lnq-meanq;
	lnpf=lnpf-meanpf;
	lf=lf-meanlf;
run;

proc reg data=test;
	model lnc=lnq lnpf lf/noint;
run;

proc panel data=week4;
	id i t;
	model LnC=LnQ LnPF LF/btwng;
run;

/*  The following program is given on page 121 and produces Output 7.6 */
proc panel data=week4;
	id i t;
	model LnC=LnQ LnPF LF/fixonetime;
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
	class i t;
	model LnC=i t LnQ LnPF LF/solution;
run;

/*  The following programs are given on page 127 and produce Output 7.10 */
proc glm data=week4;
	model LnC=LnQ LnPF LF/solution;
	output out=resid residual=res;
run;
proc univariate data=resid noprint;
	var res;
	by i;
	output out=junk mean=mean;
run;
proc print data=junk;
run;

/*  This is the program given on page 128 and produce Output 7.11 */
Proc Panel data=week4 outest=out1 covout noprint;
title 'This is the Fixed Effects Analysis';
	id i t;
	model LnC=LnQ LnPF LF/fixone;
run;

Proc Panel data=week4 outest=out2 covout noprint;
title 'This is the Random Effects Analysis';
	id i t;
	model LnC=LnQ LnPF LF/ranone;
run;
data out1;
	set out1;
	if _n_>3;
	keep LnQ LnPF LF;
run;
data out2;
	set out2;
	if _n_>3;
	keep LnQ LnPF LF;
run;
proc print data=out1;
run;
proc print data=out2;
run;

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
