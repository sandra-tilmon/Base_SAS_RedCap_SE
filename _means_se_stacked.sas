proc sort data=se.stacked ; by theme prepost ; run ;


proc means data=se.stacked stackods;
ods output summary=want;
by theme prepost ;
var answer ;
run;


proc print data=want;
run;

%ds2csv (
   data=want, 
   runmode=b, 
   csvfile=Z:\groups\ECHO-Chicago\Research\SE\means.csv
 );

proc sort data=se.stacked ; by  theme ; run ;

*  ttest - should be paired, but isn't ;
	ODS graphics on ;
	ods output ttests=_ttests conflimits=_conflimits statistics=_statistics ;
proc ttest data=se.stacked ;
 	by theme  ;
	class prepost ;
	var answer ;
run ;


%ds2csv (
   data=_statistics, 
   runmode=b, 
   csvfile=Z:\groups\ECHO-Chicago\Research\SE\statistics.csv
 );

 %ds2csv (
   data=_ttests, 
   runmode=b, 
   csvfile=Z:\groups\ECHO-Chicago\Research\SE\ttests.csv
 );
