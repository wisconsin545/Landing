/*  Define the library names */
libname mydata56 "/courses/u_northwestern.edu1/i_829657/c_4884"
access=readonly;

data week3;
    set mydata56.unemp_week_3;
   run;
   
Proc print data=week3 (obs=10);
run;

data week3;
    set mydata56.unemp_week_3;
    agesq=age*age;
    age2=agesq/10;
    rr2=rr*rr;
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
%let catvars = married;                             

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



/*  Take care of the continuous variables */
%macro means(var);
	proc sort data=week3;
		by y;
	run;
	proc means data=week3;
		var &var;
		class y;
	run;
%mend;

%means(stateur);
%means(statemb);
%means(Age);
%means(tenure);
%means(rr);
%means(age2);
%means(rr2);


/*  This is the program given on Page 159 and it produces Output 10.3 */
proc logistic data=week3;
    model y(event='1')=rr rr2 age age2 tenure slack abol seasonal head married dkids dykids smsa nwhite yrdispl school12 male stateur statemb;
run;

/* This is the model that I would use based on my prelimnary data analysus*/ 
proc logistic data=week3;
    model y(event='1')= slack abol male Married yrdispl age tenure age2;
    run;



%macro class_mean(c);
proc means data=week3 mean;
class &c. ;
var Y;
run;
%mend class_mean;

/*:
Results folder: C:\Users\dprusins\AppData\Local\Temp\JMP_SAS_Results\Submit_1144
419        /*======== BEGIN JMP Generated Code ========*/
420        ;*';*";*/;quit;run;
421        ODS _ALL_ CLOSE;
422        ODS GRAPHICS ON;
423        OPTIONS DEV=ACTXIMG;
424        FILENAME JMPRTF TEMP;
425        ODS RTF(ID=JMPRTF) FILE=JMPRTF ENCODING='wlatin1' STYLE=Statistical   NOGTITLE NOGFOOTNOTE  ;
NOTE: Writing RTF Body file: JMPRTF
426        /*========  END  JMP Generated Code ========*/
427        
428        
429        /*  Define the library names */
430        libname mydata56 "/courses/u_northwestern.edu1/i_829657/c_4884"
431        access=readonly;
NOTE: Libref MYDATA56 was successfully assigned as follows: 
      Engine:        V9 
      Physical Name: /courses/u_northwestern.edu1/i_829657/c_4884
432        


433        data week3;
434            set mydata56.unemp_week_3;
435           run;

NOTE: There were 4877 observations read from the data set MYDATA56.UNEMP_WEEK_3.
NOTE: The data set WORK.WEEK3 has 4877 observations and 22 variables.
NOTE: DATA statement used (Total process time):
      real time           0.01 seconds
      user cpu time       0.00 seconds
      system cpu time     0.00 seconds
      memory              840.31k
      OS Memory           18732.00k
      Timestamp           01/26/2013 02:27:42 PM
      Page Faults                       0
      Page Reclaims                     75
      Page Swaps                        0
      Voluntary Context Switches        67
      Involuntary Context Switches      0
      Block Input Operations            0
      Block Output Operations           1808
      

436        
437        Proc print data=week3 (obs=10);
438        run;

NOTE: There were 10 observations read from the data set WORK.WEEK3.
NOTE: PROCEDURE PRINT used (Total process time):
      real time           0.01 seconds
      user cpu time       0.02 seconds
      system cpu time     0.00 seconds
      memory              1221.03k
      OS Memory           18472.00k
      Timestamp           01/26/2013 02:27:42 PM
      Page Faults                       0
      Page Reclaims                     45
      Page Swaps                        0
      Voluntary Context Switches        0
      Involuntary Context Switches      1
      Block Input Operations            0
      Block Output Operations           0
      

439        
440        data week3;
441            set mydata56.unemp_week_3;
442            agesq=age*age;
443            age2=agesq/10;
444            rr2=rr*rr;
445        run;

NOTE: There were 4877 observations read from the data set MYDATA56.UNEMP_WEEK_3.
NOTE: The data set WORK.WEEK3 has 4877 observations and 23 variables.
NOTE: DATA statement used (Total process time):
      real time           0.03 seconds
      user cpu time       0.00 seconds
      system cpu time     0.01 seconds
      memory              873.37k
      OS Memory           18732.00k
      Timestamp           01/26/2013 02:27:42 PM
      Page Faults                       0
      Page Reclaims                     75
      Page Swaps                        0
      Voluntary Context Switches        77
      Involuntary Context Switches      0
      Block Input Operations            0
      Block Output Operations           1808
      

446        
447        /*  Confidence Intervals */
448        /*  Set some graphics options */
449        goptions reset=(global goptions);
450        goptions reset=global
451            gunit=pct
452            ftext=swissb
453            htitle=4.0
454            htext=3.0
455            cback=white
456            colors=(black)
457            border
458            device=gif
459            gsfname=grafout
460            gsfmode=replace;
461        
462        /* define overall response rate and categorical variables */
463        %let resp_rate = 0.68;
464        %let catvars = married;
465        
466        /* get bar charts of response rates by category for the
467        categorical variables with confidence intervals */
468        
469        title 'Response Rates (with 95% Confidence Intervals)';
470        footnote j=l 'Vertical line denotes the overall response rate.';
471        pattern1 v=solid c=graybb;           /* define the colors and style of the bars */
472        proc gchart data=week3;
473           hbar &catvars / type=mean
474            sumvar=y       /* the binary response variable */
475            freqlabel='#'
476            meanlabel='Mean'
477            descending        /* order by descending response rate */
478            discrete
479            ref=&resp_rate     /* draw a line at the overall response rate */
480            errorbar=both     /* show bars for confidence intervals */
481            clm=95;           /* show 95% confidence intervals */
482        run;

WARNING: Unsupported device 'GIF' for RTF(JMPRTF) destination. Using default device 'SASEMF'.
483        
484        %let catvars = Seasonal;
485        %let catvars = Abol;
486        %let catvars = slack;
487        %let catvars = NWHITE;
488        %let catvars = School12;
489        %let catvars = Male;
490        %let catvars = SMSA;
491        %let catvars = married;
492        %let catvars = DKIDS;
493        %let catvars = DYKIDS;
494        %let catvars = Head;
495        %let catvars = yrdispl;
496        
497        
498        
499        /*  Take care of the continuous variables */
500        %macro means(var);
501            proc sort data=week3;
502                by y;
503            run;
504            proc means data=week3;
505                var &var;
506                class y;
507            run;
508        %mend;
509        
510        %means(stateur);

NOTE: There were 4877 observations read from the data set WORK.WEEK3.
NOTE: PROCEDURE GCHART used (Total process time):
      real time           0.03 seconds
      user cpu time       0.02 seconds
      system cpu time     0.01 seconds
      memory              1798.71k
      OS Memory           18472.00k
      Timestamp           01/26/2013 02:27:42 PM
      Page Faults                       0
      Page Reclaims                     127
      Page Swaps                        0
      Voluntary Context Switches        40
      Involuntary Context Switches      1
      Block Input Operations            0
      Block Output Operations           360
      


NOTE: There were 4877 observations read from the data set WORK.WEEK3.
NOTE: The data set WORK.WEEK3 has 4877 observations and 23 variables.
NOTE: PROCEDURE SORT used (Total process time):
      real time           0.00 seconds
      user cpu time       0.00 seconds
      system cpu time     0.00 seconds
      memory              1986.06k
      OS Memory           19248.00k
      Timestamp           01/26/2013 02:27:42 PM
      Page Faults                       0
      Page Reclaims                     92
      Page Swaps                        0
      Voluntary Context Switches        7
      Involuntary Context Switches      0
      Block Input Operations            0
      Block Output Operations           1808
      


NOTE: There were 4877 observations read from the data set WORK.WEEK3.
NOTE: PROCEDURE MEANS used (Total process time):
      real time           0.01 seconds
      user cpu time       0.01 seconds
      system cpu time     0.00 seconds
      memory              9094.46k
      OS Memory           26704.00k
      Timestamp           01/26/2013 02:27:42 PM
      Page Faults                       0
      Page Reclaims                     2096
      Page Swaps                        0
      Voluntary Context Switches        86
      Involuntary Context Switches      0
      Block Input Operations            0
      Block Output Operations           0
      

511        %means(statemb);

NOTE: Input data set is already sorted, no sorting done.
NOTE: PROCEDURE SORT used (Total process time):
      real time           0.00 seconds
      user cpu time       0.00 seconds
      system cpu time     0.00 seconds
      memory              382.06k
      OS Memory           18984.00k
      Timestamp           01/26/2013 02:27:42 PM
      Page Faults                       0
      Page Reclaims                     39
      Page Swaps                        0
      Voluntary Context Switches        1
      Involuntary Context Switches      0
      Block Input Operations            0
      Block Output Operations           0
      


NOTE: There were 4877 observations read from the data set WORK.WEEK3.
NOTE: PROCEDURE MEANS used (Total process time):
      real time           0.01 seconds
      user cpu time       0.01 seconds
      system cpu time     0.01 seconds
      memory              9094.34k
      OS Memory           26704.00k
      Timestamp           01/26/2013 02:27:42 PM
      Page Faults                       0
      Page Reclaims                     1996
      Page Swaps                        0
      Voluntary Context Switches        86
      Involuntary Context Switches      0
      Block Input Operations            0
      Block Output Operations           0
      

512        %means(Age);

NOTE: Input data set is already sorted, no sorting done.
NOTE: PROCEDURE SORT used (Total process time):
      real time           0.00 seconds
      user cpu time       0.00 seconds
      system cpu time     0.00 seconds
      memory              382.06k
      OS Memory           18984.00k
      Timestamp           01/26/2013 02:27:42 PM
      Page Faults                       0
      Page Reclaims                     39
      Page Swaps                        0
      Voluntary Context Switches        0
      Involuntary Context Switches      0
      Block Input Operations            0
      Block Output Operations           0
      


NOTE: There were 4877 observations read from the data set WORK.WEEK3.
NOTE: PROCEDURE MEANS used (Total process time):
      real time           0.01 seconds
      user cpu time       0.00 seconds
      system cpu time     0.00 seconds
      memory              9093.62k
      OS Memory           26960.00k
      Timestamp           01/26/2013 02:27:42 PM
      Page Faults                       0
      Page Reclaims                     2022
      Page Swaps                        0
      Voluntary Context Switches        86
      Involuntary Context Switches      0
      Block Input Operations            0
      Block Output Operations           0
      

513        %means(tenure);

NOTE: Input data set is already sorted, no sorting done.
NOTE: PROCEDURE SORT used (Total process time):
      real time           0.00 seconds
      user cpu time       0.00 seconds
      system cpu time     0.00 seconds
      memory              382.06k
      OS Memory           18984.00k
      Timestamp           01/26/2013 02:27:42 PM
      Page Faults                       0
      Page Reclaims                     39
      Page Swaps                        0
      Voluntary Context Switches        0
      Involuntary Context Switches      0
      Block Input Operations            0
      Block Output Operations           0
      


NOTE: There were 4877 observations read from the data set WORK.WEEK3.
NOTE: PROCEDURE MEANS used (Total process time):
      real time           0.01 seconds
      user cpu time       0.01 seconds
      system cpu time     0.01 seconds
      memory              9100.93k
      OS Memory           26960.00k
      Timestamp           01/26/2013 02:27:42 PM
      Page Faults                       0
      Page Reclaims                     2046
      Page Swaps                        0
      Voluntary Context Switches        86
      Involuntary Context Switches      0
      Block Input Operations            0
      Block Output Operations           0
      

514        %means(rr);

NOTE: Input data set is already sorted, no sorting done.
NOTE: PROCEDURE SORT used (Total process time):
      real time           0.00 seconds
      user cpu time       0.00 seconds
      system cpu time     0.00 seconds
      memory              382.06k
      OS Memory           18984.00k
      Timestamp           01/26/2013 02:27:42 PM
      Page Faults                       0
      Page Reclaims                     39
      Page Swaps                        0
      Voluntary Context Switches        0
      Involuntary Context Switches      0
      Block Input Operations            0
      Block Output Operations           0
      


NOTE: There were 4877 observations read from the data set WORK.WEEK3.
NOTE: PROCEDURE MEANS used (Total process time):
      real time           0.02 seconds
      user cpu time       0.00 seconds
      system cpu time     0.00 seconds
      memory              9092.18k
      OS Memory           26960.00k
      Timestamp           01/26/2013 02:27:42 PM
      Page Faults                       0
      Page Reclaims                     2046
      Page Swaps                        0
      Voluntary Context Switches        86
      Involuntary Context Switches      1
      Block Input Operations            0
      Block Output Operations           0
      

515        %means(Age*Age);

NOTE: Input data set is already sorted, no sorting done.
NOTE: PROCEDURE SORT used (Total process time):
      real time           0.00 seconds
      user cpu time       0.00 seconds
      system cpu time     0.00 seconds
      memory              382.06k
      OS Memory           18984.00k
      Timestamp           01/26/2013 02:27:42 PM
      Page Faults                       0
      Page Reclaims                     39
      Page Swaps                        0
      Voluntary Context Switches        0
      Involuntary Context Switches      0
      Block Input Operations            0
      Block Output Operations           0
      


NOTE: The SAS System stopped processing this step because of errors.
NOTE: PROCEDURE MEANS used (Total process time):
      real time           0.00 seconds
      user cpu time       0.00 seconds
      system cpu time     0.00 seconds
      memory              346.06k
      OS Memory           18984.00k
      Timestamp           01/26/2013 02:27:42 PM
      Page Faults                       0
      Page Reclaims                     40
      Page Swaps                        0
      Voluntary Context Switches        0
      Involuntary Context Switches      0
      Block Input Operations            0
      Block Output Operations           0
      
NOTE: Line generated by the macro variable "VAR".
515         Age*Age
               _
               22
               200

516        %means(agesq);



NOTE: Input data set is already sorted, no sorting done.
NOTE: PROCEDURE SORT used (Total process time):
      real time           0.00 seconds
      user cpu time       0.00 seconds
      system cpu time     0.00 seconds
      memory              383.06k
      OS Memory           18984.00k
      Timestamp           01/26/2013 02:27:42 PM
      Page Faults                       0
      Page Reclaims                     39
      Page Swaps                        0
      Voluntary Context Switches        0
      Involuntary Context Switches      0
      Block Input Operations            0
      Block Output Operations           0
      


NOTE: There were 4877 observations read from the data set WORK.WEEK3.
NOTE: PROCEDURE MEANS used (Total process time):
      real time           0.01 seconds
      user cpu time       0.00 seconds
      system cpu time     0.01 seconds
      memory              9099.59k
      OS Memory           26960.00k
      Timestamp           01/26/2013 02:27:42 PM
      Page Faults                       0
      Page Reclaims                     2046
      Page Swaps                        0
      Voluntary Context Switches        86
      Involuntary Context Switches      0
      Block Input Operations            0
      Block Output Operations           0
      

517        %means(age2);

NOTE: Input data set is already sorted, no sorting done.
NOTE: PROCEDURE SORT used (Total process time):
      real time           0.00 seconds
      user cpu time       0.00 seconds
      system cpu time     0.00 seconds
      memory              381.71k
      OS Memory           18984.00k
      Timestamp           01/26/2013 02:27:42 PM
      Page Faults                       0
      Page Reclaims                     39
      Page Swaps                        0
      Voluntary Context Switches        1
      Involuntary Context Switches      0
      Block Input Operations            0
      Block Output Operations           0
      


NOTE: There were 4877 observations read from the data set WORK.WEEK3.
NOTE: PROCEDURE MEANS used (Total process time):
      real time           0.01 seconds
      user cpu time       0.01 seconds
      system cpu time     0.00 seconds
      memory              9094.48k
      OS Memory           26960.00k
      Timestamp           01/26/2013 02:27:42 PM
      Page Faults                       0
      Page Reclaims                     2046
      Page Swaps                        0
      Voluntary Context Switches        86
      Involuntary Context Switches      0
      Block Input Operations            0
      Block Output Operations           0
      

518        %means(rr2);

NOTE: Input data set is already sorted, no sorting done.
NOTE: PROCEDURE SORT used (Total process time):
      real time           0.00 seconds
      user cpu time       0.00 seconds
      system cpu time     0.00 seconds
      memory              381.71k
      OS Memory           18984.00k
      Timestamp           01/26/2013 02:27:42 PM
      Page Faults                       0
      Page Reclaims                     39
      Page Swaps                        0
      Voluntary Context Switches        0
      Involuntary Context Switches      0
      Block Input Operations            0
      Block Output Operations           0
      


NOTE: There were 4877 observations read from the data set WORK.WEEK3.
NOTE: PROCEDURE MEANS used (Total process time):
      real time           0.01 seconds
      user cpu time       0.00 seconds
      system cpu time     0.01 seconds
      memory              9094.23k
      OS Memory           26960.00k
      Timestamp           01/26/2013 02:27:42 PM
      Page Faults                       0
      Page Reclaims                     2046
      Page Swaps                        0
      Voluntary Context Switches        87
      Involuntary Context Switches      0
      Block Input Operations            0
      Block Output Operations           0
      

519        
520        
521        /*  This is the program given on Page 159 and it produces Output 10.3 */
522        proc logistic data=week3;
523            model y(event='1')=rr rr2 age age2 tenure slack abol seasonal head married dkids dykids smsa nwhite yrdispl school12
523      ! male stateur statemb;
524        run;

NOTE: PROC LOGISTIC is modeling the probability that y='1'.
NOTE: Convergence criterion (GCONV=1E-8) satisfied.
NOTE: There were 4877 observations read from the data set WORK.WEEK3.
NOTE: PROCEDURE LOGISTIC used (Total process time):
      real time           0.28 seconds
      user cpu time       0.04 seconds
      system cpu time     0.01 seconds
      memory              2805.15k
      OS Memory           20864.00k
      Timestamp           01/26/2013 02:27:42 PM
      Page Faults                       0
      Page Reclaims                     294
      Page Swaps                        0
      Voluntary Context Switches        394
      Involuntary Context Switches      87
      Block Input Operations            0
      Block Output Operations           1824
      

525        
526        /* This is the model that I would use based on my prelimnary data analysus*/
527        proc logistic data=week3;
528            model y(event='1')= slack abol male Married yrdispl age tenure age2;
529            run;

NOTE: PROC LOGISTIC is modeling the probability that y='1'.
NOTE: Convergence criterion (GCONV=1E-8) satisfied.
NOTE: There were 4877 observations read from the data set WORK.WEEK3.
NOTE: PROCEDURE LOGISTIC used (Total process time):
      real time           0.06 seconds
      user cpu time       0.02 seconds
      system cpu time     0.00 seconds
      memory              2298.01k
      OS Memory           20444.00k
      Timestamp           01/26/2013 02:27:42 PM
      Page Faults                       0
      Page Reclaims                     190
      Page Swaps                        0
      Voluntary Context Switches        390
      Involuntary Context Switches      0
      Block Input Operations            0
      Block Output Operations           1120
      

530        
531        
532        
533        %macro class_mean(c);
534        proc means data=week3 mean;
535        class &c. ;
536        var Y;
537        run;
538        %mend class_mean;
539        
540        
541        
542        
543        /*======== BEGIN JMP Generated Code ========*/
544        ;*';*";*/;quit;run;
545        ODS GRAPHICS OFF;
546        ODS _ALL_ CLOSE;
547        ODS LISTING;
548        QUIT; RUN;
549        /*========  END  JMP Generated Code ========*/
550        

====================================================================================================
