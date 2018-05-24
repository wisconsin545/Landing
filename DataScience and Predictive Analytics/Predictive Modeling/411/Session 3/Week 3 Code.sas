/*  Define the library names */
libname mydata56 "/courses/u_northwestern.edu1/i_829657/c_4884"
access=readonly;

data week3;
    set mydata56.unemp_week_3;
    agesq=age*age;
    age2=agesq/10;
run;

/*  Confidence Intervals */
/*  Set some graphics options */                                
goptions reset=(global goptions);                              
goptions reset=global                                          
	gunit=pct                                             
	ftext=swissb                                          
	htitle=4.0                                            
	htext=3.0                                             
	cback=white                                           
	colors=(black)                                        
	border
	device=gif
	gsfname=grafout
	gsfmode=replace;                                               

/* define overall response rate and categorical variables */   
%let resp_rate = 0.68;                                          
%let catvars = abol;                             

/* get bar charts of response rates by category for the        
categorical variables with confidence intervals */          

title 'Response Rates (with 95% Confidence Intervals)';        
footnote j=l 'Vertical line denotes the overall response rate.';
pattern1 v=solid c=graybb;           /* define the colors and style of the bars */
proc gchart data=week3;                                       
   hbar &catvars / type=mean                                    
	sumvar=y       /* the binary response variable */
	freqlabel='#'                               
	meanlabel='Mean'                            
	descending        /* order by descending response rate */                                 
	discrete  
	ref=&resp_rate     /* draw a line at the overall response rate */
	errorbar=both     /* show bars for confidence intervals */                          
	clm=95;           /* show 95% confidence intervals */
run;

%let catvars = Seasonal;  
%let catvars = Abol;  
%let catvars = slack;  
%let catvars = NWHITE; 
%let catvars = School12;
%let catvars = Male; 
%let catvars = SMSA; 
%let catvars = married; 
%let catvars = DKIDS; 
%let catvars = DYKIDS; 
%let catvars = Head; 
%let catvars = yrdispl; 









/*  This is the program given on Page 162 and it produces Output 10.4 */
proc logistic data=rockinweek3;
    model y(event='1')=rr rr2 age age2 tenure slack abol seasonal head married dkids dykids smsa
nwhite yrdispl school12 male stateur statemb/l=probit;
run;

*****Let's check out the Data*****;
proc print data=rockinweek3 (obs=10);run; quit;
proc contents data=rockinweek3; run; quit;

proc freq data=rockinweek3;
tables stateur	statemb	state	age	age2	
tenure	slack	abol	seasonal	nwhite	
school12	male	bluecol	smsa	married	
dkids	dykids	yrdispl	rr	rr2	head ;
run;

proc means data=rockinweek3 p5 p10 p25 p50 p75 p90 p95;
class Y;
var stateur	statemb	state	age	age2	
tenure	slack	abol	seasonal	nwhite 
married	dkids	dykids	yrdispl	rr	rr2	head; 	
run;

/*  Define the library names */
libname mydata56 "/courses/u_northwestern.edu1/i_829657/c_4884"
access=readonly;

data rockinweek3;
	set mydata56.unemp_week_3;
run;

proc logistic data=rockinweek3;
model Y (Event='1') = stateur	statemb	state	age	age2	
tenure	slack	abol	seasonal	nwhite	
school12	male	smsa	married	
dkids	dykids	yrdispl	rr	rr2	head/1=Probit;
run;

proc corr data=rockinweek3 nosimple rank plots = matrix(histogram nvar=all);
	var y stateur statemb age age2 tenure rr rr2;
	with y stateur statemb age age2 tenure rr rr2;
run;


%macro class_mean(c);
proc means data=rockinweek3 mean;
class &c. ;
var Y;
run;
%mend class_mean;

%class_mean(c=slack);
%class_mean(c=abol);
%class_mean(c= nwhite);
%class_mean(c=seasonal);
%class_mean(c=school12);
%class_mean(c= male);
%class_mean(c= smsa);
%class_mean(c= married);
%class_mean(c= dkids);
%class_mean(c= dykids);
%class_mean(c= head);