/* 	Chad R. Bhatti
	03.25.2012
	libname_read.sas
*/


/* 	Everyone should be using this exact libname statement.  It is important that
	you include the access option.
*/

libname mydata 	'/courses/u_northwestern.edu1/i_833463/c_3505/SAS_Data/' access=readonly; 


/* 	List all data sets in a directory.  If the lib parameter is not specified, PROC 
	DATASETS defaults to the work directory.
*/
proc datasets lib=mydata; run; quit;



* List the meta data associated with a SAS data set;
proc contents data=mydata.building_prices; run;


* Read in a SAS data set from mylib;

data temp;
	set mydata.building_prices;
run;


* Print the first 10 observations on this data set;
proc print data=temp(obs=10); run; quit;





