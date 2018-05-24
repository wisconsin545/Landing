/*  Define the library names */
libname mydata56 "/courses/u_northwestern.edu1/i_829657/c_4884" access=readonly;
libname mydata57 "/courses/u_northwestern.edu1/i_829657/c_4885" access=readonly;
libname mydata58 "/courses/u_northwestern.edu1/i_829657/c_4886" access=readonly;

Data Expense;
    set mydata56.credit_card_week_2;
    age_sq=age*age;
    incomesq=income*income;
    If AvgExp>0;
run;
proc reg data=Expense;
    model AvgExp = Age OwnRent Income IncomeSq;
    output out=for_graphs student=r_s;
run;


/*  This is the program given on page 75 and one that produces output 5.2 */

Data Expense;
    set mydata56.credit_card_week_2;
    age_sq=age*age;
    incomesq=income*income;
    incomefth=incomesq*incomesq;
    age_or=age*ownrent;
    age_inc=age*income;
    age_incsq=age*incomesq;
    or_income=ownrent*income;
    or_incomesq=ownrent*incomesq;
    incomecube=income*incomesq;
    If AvgExp>0;
run;
proc IML;
    /*  This program illustrates the computation of the White test for Heteroscedasticity.  */
    /*  The data set in Table F9.1 of Greene is used.                                       */
    /*  Read the data into matrices.                                                        */
    use Expense;
    read all var {'age' 'ownrent' 'income' 'incomesq'} into X;
    read all var {'age' 'ownrent' 'income' 'incomesq' 'age_sq' 'incomefth' 'age_or'
    'age_inc' 'age_incsq' 'or_income' 'or_incomesq' 'incomecube'} into XP;
    read all var {'avgexp'} into Y;

    n=nrow(X);
    np=nrow(XP);
    X=J(n,1,1)||X;
    XP=J(np,1,1)||XP;

    k=ncol(X);
    kp=ncol(XP);

    /*  First get the residuals from OLS. */
    C=inv(X`*X);
    beta_hat=C*X`*y;
    resid=y-X*beta_hat;

    /*  Square the residuals for preparing a regression with cross product terms in White's */
    /*  test. */
    resid_sq=resid#resid;
    /*  Regress the square of the residuals versus the 13 variables in X. */

    C_E=inv(XP`*XP);
    b_hat_e=C_E*XP`*resid_sq;

    /*  Calculate RSquare from this regression. */
    Mean_Y=Sum(resid_sq)/np;
    SSR=b_hat_e`*XP`*resid_sq-np*Mean_Y**2;
    SSE=resid_sq`*resid_sq-b_hat_e`*XP`*resid_sq;
    SST=SSR+SSE;
    R_Square=SSR/SST;
    print R_Square;

    /*  Calculate and print the test statistic value and corresponding p-value. */
    White=np*R_Square;
    pvalue= 1 - probchi(White, kp-1);
    print 'The test statistic value for Whites Test is 'White;
    print 'The p-value associated with this test is 'pvalue;
run;

/*  This is the program given on page 76 and one that produces output 5.3 */

Data Expense;
    set mydata56.credit_card_week_2;
    age_sq=age*age;
    incomesq=income*income;
    incomefth=incomesq*incomesq;
    age_or=age*ownrent;
    age_inc=age*income;
    age_incsq=age*incomesq;
    or_income=ownrent*income;
    or_incomesq=ownrent*incomesq;
    incomecube=income*incomesq;
    If AvgExp>0;
run;
proc model data=Expense;
      parms Const C_Age C_OwnRent C_Income C_IncomeSq ;
      AvgExp = Const + C_Age*Age + C_OwnRent*OwnRent + C_Income*Income + C_IncomeSq*Income*Income;
      income_sq = income * income;
      fit AvgExp / white breusch=(1 Income Income_Sq);
run;

/*  This is the program given on page 78 and it produces output 5.4 */

Data Expense;
    set mydata56.credit_card_week_2;
    incomesq=income*income;
    if avgexp>0;
run;
proc sort data=Expense;
    by income;
run;
data Expense;
    set Expense;
    if _n_ < 37 then id=1;else id=2;
run;
proc reg data=Expense outest=est noprint;
    model avgexp=age ownrent income incomesq;
    by id;
run;
proc print data=est;
run;

/*  This is the program given on page 80 and produces output 5.5 */

Data Expense;
    set mydata56.credit_card_week_2;
    incomesq=income*income;
    if avgexp>0;
run;
proc iml;

/*  Read the data into matrices and prep matrices for analysis. */

    use expense;
    read all var {'age' , 'ownrent' ,'income' ,'incomesq' } into X;
    read all var {'income' , 'incomesq' } into Z;
    read all var {'avgexp' } into y;
    n=nrow(X);
    X=J(n,1,1)||X;
    Z=J(n,1,1)||Z;

/*  Calculate the residuals from OLS. */

    bhat_OLS=inv(X`*X)*X`*y;
    SSE=(y-X*bhat_OLS)`*(y-X*bhat_OLS);
    resid=y-X*bhat_OLS;

/*  Calculate the LM statistic and associated p value. */

    g=J(n,1,0);
    fudge=SSE/n;
    do index=1 to n;
        temp1=resid[index,1]*resid[index,1];
        g[index,1]=temp1/fudge - 1;
    end;
    LM=0.5*g`*Z*inv(Z`*Z)*Z`*g;
    kz=ncol(Z);
    kz=kz-1;
    pval=1-probchi(LM,kz);
    if (pval<0.05) then
        do;
         print 'The Breusch Pagan Test Statistic Value is 'LM;
         print 'The p value associated with this is 'pval;
         print 'The null hypothesis of homoscedasticity is rejected';
        end;
    else
        do;
         print 'The Breusch Pagan Test Statistic Value is 'LM;
         print 'The p value associated with this is 'pval;
         print 'The null hypothesis of homoscedasticity is not rejected';
        end;
run;

/*  Proc IML Demo for Week 2 Office Hours */

/*  This is the analysis of table F3.1 of Greene (2003)   */

/*  In the following data step, we read the raw data,     */
/*  create a trend variable, T, divide GNP and Invest     */
/*  by CPI and then scale the transformed GNP and Invest  */
/*  time series so that they are measured in trillions of */
/*  dollars.                                              */

Data invst_equation;
    input year gnp invest cpi interest;
    T=_n_;
    Real_GNP=GNP/(CPI*10);
    Real_Invest=Invest/(CPI*10);
    cards;
1968    873.4   133.3   82.54   5.16
1969    944 149.3   86.79   5.87
1970    992.7   144.2   91.45   5.95
1971    1077.6  166.4   96.01   4.88
1972    1185.9  195 100 4.5
1973    1326.4  229.8   105.75  6.44
1974    1434.2  228.7   115.08  7.83
1975    1549.2  206.1   125.79  6.25
1976    1718    257.9   132.34  5.5
1977    1918.3  324.1   140.05  5.46
1978    2163.9  386.6   150.42  7.46
1979    2417.8  423 163.42  10.28
1980    2633.1  402.3   178.64  11.77
1981    2937.7  471.5   195.51  13.42
1982    3057.5  421.9   207.23  11.02
;
run;

/*  The start of Proc IML routines. */
PROC IML;

    /*  Invoke Proc IML and create the X and Y matrices using the variables T, Real_GNP, and Real_Invest */
    /*  from the SAS data set invst_equation.                                    */

    use invst_equation;
    read all var {'T' 'Real_GNP'} into X;
    read all var {'Real_Invest'} into Y;

    /*  Define the number of observations and the number of independent variables. */

    n=nrow(X);
    k=ncol(X);

    /*  Create a column of ones to the X matrix to account for the intercept term. */

    X=J(n,1,1)||X;

    /*  Calculate the inverse of X'X and use this to compute B_Hat */
    

    C=inv(X`*X);
    B_Hat=C*X`*Y;

    /*  Compute SSE, the residual sum of squares, and MSE, the */
    /*  residual mean square.                                  */

    SSE=y`*y-B_Hat`*X`*Y;
    DFE=n-k-1;
    MSE=sse/DFE;

    /*  Compute SSR, the sums of squares due to the model, and MSR, the sums of squares due */
    /*  due to random error, and the F ratio.                                                       */

    Mean_Y=Sum(Y)/n;
    SSR=B_Hat`*X`*Y-n*Mean_Y**2;

    MSR=SSR/k;
    F=MSR/MSE;

    /*  Compute the coefficient of determination and the adjusted coefficient of determination */

    SST=SSR+SSE;
    R_Square=SSR/SST;
    Adj_R_Square=1-(n-1)/(n-k-1) * (1-R_Square);

    /*  Compute the standard error of the parameter estimates, their T statistic and P-values. */

    SE=SQRT(vecdiag(C)#MSE);
    T=B_Hat/SE;
    PROBT=2*(1-CDF('T', ABS(T), DFE));

    /*  Concatenate the results into one matrix. */

    Source=(k||SSR||MSR||F)//(DFE||SSE||MSE||{.});
    STATS=B_Hat||SE||T||PROBT;
    Print 'Regression Results for the Investment Equation';
    Print Source (|Colname={DF SS MS F} rowname={Model Error} format=8.4|);
    Print 'Parameter Estimates';
    Print STATS (|Colname={BHAT SE T PROBT} rowname={INT T Real_GNP} format=8.4|);
    Print '';
    Print 'The value of R-Square is ' R_Square [format=8.4];
    Print 'The value of Adj R-Square is ' Adj_R_Square [format=8.4];

RUN;

Proc Reg Data=invst_equation;
    Model Real_Invest=Real_GNP T;
Run;

