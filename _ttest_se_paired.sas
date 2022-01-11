DATA prepostcred ;
	set se.prepostcred ;
	if TimeStamp <= '22NOV2019'd ;
run ;

proc sort data=prepostcred ; by theme  ; run ;


proc means data=prepostcred stackods;
ods output summary=theme;
by theme  ;
var pre post delta ;
run;


%ds2csv (
   data=theme, 
   runmode=b, 
   csvfile=Z:\groups\ECHO-Chicago\Research\SE\theme_means.csv
 );


*  ttest paired ;
	ODS graphics on ;
	ods output ttests=_ttests conflimits=_conflimits statistics=_statistics ;
proc ttest data=prepostcred  ;
	paired post*pre;
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

  %ds2csv (
   data=_conflimits, 
   runmode=b, 
   csvfile=Z:\groups\ECHO-Chicago\Research\SE\conflimits.csv
 );


 
 
 proc sort data=prepostcred ; by Prescriber ;

*  ttest paired ;
	ODS graphics on ;
	ods output ttests=pres_ttests conflimits=pres_conflimits statistics=pres_statistics ;
proc ttest data=prepostcred  ;
	by Prescriber ;
	paired post*pre;
run ;


%ds2csv (
   data=pres_statistics, 
   runmode=b, 
   csvfile=Z:\groups\ECHO-Chicago\Research\SE\pres_statistics.csv
 );

 %ds2csv (
   data=pres_ttests, 
   runmode=b, 
   csvfile=Z:\groups\ECHO-Chicago\Research\SE\pres_ttests.csv
 );

  %ds2csv (
   data=pres_conflimits, 
   runmode=b, 
   csvfile=Z:\groups\ECHO-Chicago\Research\SE\pres_conflimits.csv
 ); 
 
 proc sort data=prepostcred ; by credentialtxt ;

*  ttest paired ;
	ODS graphics on ;
	ods output ttests=cred_ttests conflimits=cred_conflimits statistics=cred_statistics ;
proc ttest data=prepostcred  ;
	by credentialtxt ;
	paired post*pre;
run ;


%ds2csv (
   data=cred_statistics, 
   runmode=b, 
   csvfile=Z:\groups\ECHO-Chicago\Research\SE\cred_statistics.csv
 );

 %ds2csv (
   data=cred_ttests, 
   runmode=b, 
   csvfile=Z:\groups\ECHO-Chicago\Research\SE\cred_ttests.csv
 );

  %ds2csv (
   data=cred_conflimits, 
   runmode=b, 
   csvfile=Z:\groups\ECHO-Chicago\Research\SE\cred_conflimits.csv
 ); 
 
 proc sort data=prepostcred ; by project2 ;

*  ttest paired ;
	ODS graphics on ;
	ods output ttests=proj_ttests conflimits=proj_conflimits statistics=proj_statistics ;
proc ttest data=prepostcred  ;
	by project2 ;
	paired post*pre;
run ;


%ds2csv (
   data=proj_statistics, 
   runmode=b, 
   csvfile=Z:\groups\ECHO-Chicago\Research\SE\proj_statistics.csv
 );

 %ds2csv (
   data=proj_ttests, 
   runmode=b, 
   csvfile=Z:\groups\ECHO-Chicago\Research\SE\proj_ttests.csv
 );

   %ds2csv (
   data=proj_conflimits, 
   runmode=b, 
   csvfile=Z:\groups\ECHO-Chicago\Research\SE\proj_conflimits.csv
 ); 
