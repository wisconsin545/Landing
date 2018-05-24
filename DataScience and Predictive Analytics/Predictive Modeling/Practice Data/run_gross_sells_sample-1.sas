/* 
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
*/

ODS GRAPHICS ON; * needed for high-resolution graphics;

TITLE "Gross Sells Demonstration";

/* Read in the demographics data without header row */
/* Make sure course identifier is correct c_3596 is for PREDICT 410 (Miller) */

FILENAME demo '/courses/u_northwestern.edu1/i_810095/c_3596/gross_sells_demodat.csv'; 
DATA demodat;
INFILE demo DSD;
INPUT INDIVIDUAL_ID MED_INC MED_HOME_VALUE MED_RENT MED_LENGTH_OF_RESIDENCE
NUM_CHILD NUMB_ADLT ADVERTISING AVG_NO_OF_BANK_ACCNT OWN_HOME LOR MARRIAGE_STATUS
INTESTEST_IN_SPORT INTEREST_IN_DIY INTEREST_IN_TRAVEL GENDER $ AGE;
DATALINES;
 ...
RUN;

/* Read in the sales data without header row and with dates as character strings */
/* Make sure course identifier is correct c_3596 is for PREDICT 410 (Miller) */

FILENAME sales '/courses/u_northwestern.edu1/i_810095/c_3596/gross_sells_salesdat.csv'; 
DATA salesdat;
INFILE sales DSD;
INPUT INDIVIDUAL_ID LTD_GROSS_NUM_ORDERS LTD_GROSS_PURCHASE_AMT LTD_GROSS_PURCHASE_UNITS
 LTD_AVG_ORDER_AMT LTD_AVG_ORDER_UNITS FIRST_PURCHASE_DATE $ FIRST_PURCHASE_AMT      
 LAST_PURCHASE_DATE $ LAST_PURCHASE_AMT CLOSEST_STORE_DISTANCE RETAIL_DOLLARS          
 RETAIL_ORDERS DIRECT_DOLLARS DIRECT_ORDERS GROSS_SELL_AMT GROSS_QTY RESP_IND;
 DATALINES;
 ...
RUN;
 
PROC SORT DATA=demodat OUT=demosrt; BY INDIVIDUAL_ID;
PROC SORT DATA=salesdat OUT=salessrt; BY INDIVIDUAL_ID;

/* Merge the demographics and sales data */
DATA alldat;
MERGE demosrt salessrt;
BY INDIVIDUAL_ID;
IF GROSS_SELL_AMT = . THEN GROSS_SELL_AMT = 0; * for sales missing data are zeroes;
RUN;

* show contents of the full data set prior to splitting;
* notice that we have an error here.... dataset building is not available to us;
PROC CONTENTS DATA = building;
RUN;

* print first 20 observations checking values of selected variables;
OPTIONS OBS = 20;
PROC PRINT DATA = alldat; 
VAR GROSS_SELL_AMT LTD_GROSS_PURCHASE_AMT MED_INC;
RUN;
OPTIONS OBS = MAX; * reset options to analyze and report on all data;

* summary statistics; 
PROC UNIVARIATE DATA = alldat;
VAR GROSS_SELL_AMT LTD_GROSS_PURCHASE_AMT MED_INC;
RUN;

* correlation and scatterplot;
PROC CORR DATA = alldat PLOTS = SCATTER;
VAR GROSS_SELL_AMT; 
WITH LTD_GROSS_PURCHASE_AMT;
RUN;

TITLE2 "Simple Linear Regression of Promotional Sales on Lifetime Purchases";
* simple linear regression with graphics MAXPOINTS default of 5000 overridden;
PROC REG DATA = alldat PLOTS(MAXPOINTS=NONE);  
MODEL GROSS_SELL_AMT = LTD_GROSS_PURCHASE_AMT; 
* save predicted response values in a SAS dataset called learnout;
OUTPUT OUT = learnout PREDICTED = PRED; * PRED is the predicted sales; 
RUN;

* examine observed and predicted response case by case;
* print first 20 observations checking values of selected variables;
OPTIONS OBS = 20;
PROC PRINT DATA = learnout; 
VAR MED_INC GROSS_SELL_AMT PRED;
RUN;
OPTIONS OBS = MAX; * reset options to analyze and report on all data;

* correlation of actual and predicted response;
PROC CORR DATA = learnout PLOTS = SCATTER;
VAR PRED; 
WITH GROSS_SELL_AMT;
RUN;

ODS GRAPHICS OFF; * turn off high-resolution graphics;


QUIT;