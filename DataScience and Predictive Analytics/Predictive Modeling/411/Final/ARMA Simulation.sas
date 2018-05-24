/*  Series 0 */
/*  y_t = 0.5 y_(t-1) + e_t + 0.8 e_(t-1) */
proc iml;
      phi={1 -0.5};
      theta={1 0.8};
      y=armasim(phi, theta, 0, 1, 10, -1234321);
      print y;
run;

/*  Series 1  */
/*  y_t = 0.8 y_(t-1) + e_t */
proc iml;
      phi={1 -0.8};
      theta={1};
      y=armasim(phi, theta, 0, 1, 20, -1234321);
      print y;
	  series1 = y;
  	  cname = {"Series1" };
  	  create out from Series1 [ colname=cname ];
  	  append from Series1;
run;
proc arima data=work.out;
	identify var=series1;
run;


/*  Series 2 */
/*  y_t = -0.8 y_(t-1) + e_t */
proc iml;
      phi={1 0.8};
      theta={1};
      y=armasim(phi, theta, 0, 1, 20, -1234321);
      print y;
	  series2 = y;
  	  cname = {"Series2" };
  	  create out from Series2 [ colname=cname ];
  	  append from Series2;
run;
proc arima data=work.out;
	identify var=series2;
run;

/*  Series 3  */
/*  y_t = 0.3 y_(t-1) + 0.4 y_(t-1) + e_t */
proc iml;
      phi={1 -0.3 -0.4};
      theta={1};
      y=armasim(phi, theta, 0, 1, 100, -1234321);
      print y;
	  series3 = y;
  	  cname = {"Series3" };
  	  create out from Series3 [ colname=cname ];
  	  append from Series3;
run;
proc arima data=work.out;
	identify var=series3;
run;

/*  Series 4  */
/*  y_t = 0.7 y_(t-1) - 0.49 y_(t-2) + e_t */
proc iml;
      phi={1 -0.7 0.49};
      theta={1};
      y=armasim(phi, theta, 0, 1, 1000, -1234321);
	  series4 = y;
  	  cname = {"Series4" };
  	  create out from Series4 [ colname=cname ];
  	  append from Series4;
run;
proc arima data=work.out;
	identify var=series4;
	estimate p=2;
run;

/*  Series 5 */
/*y_t = 0.8 y_(t-1) - 0.6 y_(t-2) + 0.4 y_(t-3) + e_t */
proc iml;
      phi={1 -0.8 0.6 -0.4};
      theta={1};
      y=armasim(phi, theta, 0, 1, 1000, -1234321);
	  series5 = y;
  	  cname = {"Series5" };
  	  create out from Series5 [ colname=cname ];
  	  append from Series5;
run;
proc arima data=work.out;
	identify var=series5;
	estimate p=3 nointercept;
run;