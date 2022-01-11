**********************************************************************;
* Project           : ECHO-Chicago
*
* Program name      : Test
*
* Author            : Sandra Tilmon
*
* Date created      : 9/14/2018
*
* Purpose           : Stack ALL pre/post projects
*
* Revision History  :
*
* Date        Author      Ref    Revision (Date in YYYYMMDD format) 
*
**********************************************************************;

* ALL PROJECTS ;

/*proc freq data=_prepost ; tables project2 / list missing ; run ;*/

libname redcap 'Z:\groups\ECHO-Chicago\Data\Processed\Redcap' ;

DATA _prepost ;
	set 
		ADHDAPR.REDPREPOSTWIDEMIN
		ADHDOCT.REDPREPOSTWIDEMIN
		ADOL.REDPREPOSTWIDEMIN
		BHCOLL.REDPREPOSTWIDEMIN
		BHPSY.REDPREPOSTWIDEMIN
		CAT.REDPREPOSTWIDEMIN
		CPA.REDPREPOSTWIDEMIN
		EPILEPSY.REDPREPOSTWIDEMIN
		GERI.REDPREPOSTWIDEMIN
		GERISNF.REDPREPOSTWIDEMIN
		HCV.REDPREPOSTWIDEMIN
		HTN.REDPREPOSTWIDEMIN
		OBESITY.REDPREPOSTWIDEMIN
		OPIATES.REDPREPOSTWIDEMIN 
		RBWH.REDPREPOSTWIDEMIN
		SMI.REDPREPOSTWIDEMIN
;
	format SEDiff 4.2 ;

id = catx(',', Project, idvar) ;

*where timestamp >= '01JUL2016'd ;

project2 = project ;
if project in ("ADHDApr", "ADHDOct") then project2 = "ADHD" ;

SEDiff = PostSEAvg - PreSEAvg ;

SEImprove = . ;
	IF PostSEAvg > PreSEAvg then DO ;
		SEImprove = 1 ;
	END ;
	IF PostSEAvg <= PreSEAvg then DO ;
		SEImprove = 0 ;
	END ;

SELevel = . ;
	IF SEDiff > .7 then DO ;
		SELevel = 1 ;
	END ;
	IF -100 < SEDiff < .7 then DO ;
		SELevel = 0 ;
	END ;

if project = "Adol" then DO ;
	if cohort = . then DO ;
		cohort = 1 ;
	end ;
end ;

if project = "BHColl" then DO ;
	if cohort = . then DO ;
		cohort = 1 ;
	end ;
end ;

id = catx(',', project, idvar) ;

FiscalYear = Year(PostTimeStamp) ;
	if 7<=Month(PostTimeStamp) <=12 then DO ;
		FiscalYear = Year(PostTimeStamp) +1 ;
end ;

* if PostTimeStamp > '22Nov2019'd then DELETE ; * to limit for SE paper ;

drop pre post ;
run ;

DATA redcap.prepost ;
	set _prepost ;
run ;

proc freq data=_prepost ;
	*tables project2*(cohort SEDiff SEImprove SELevel) / list missing ;
	*tables PostTimeStamp*(FiscalYear) / list missing ;
	*tables Project2 ;
	tables PostTimeStamp / list missing ;
run ;

* Save summary file to .csv ;
	PROC EXPORT DATA=_prepost
		outfile="Z:\groups\ECHO-Chicago\Data\Processed\RedCap\PrePost.csv" replace
		dbms=csv ;
		delimiter=',' ;
	run ;

* save to redcap ;
DATA redcap.REDPREPOSTWIDEMIN ;
	set _prepost ;
run ;

* Overall ;
	
	PROC SORT data=_prepost ; by project2 ;
	title ' Overall ' ;
	proc TTEST DATA=_PREPOST ;
		paired PostSEAvg*PreSEAvg; 
	run ; title ;

* Test by project ;

ods output ttests=_ttestsA conflimits=_conflimitsA statistics=_statisticsA ;
	title ' By Project ' ;
	proc sort data=_prepost ; by project2 ;
	proc TTEST DATA=_PREPOST plots=none;
		by project2 ;
		paired PostSEAvg*PreSEAvg;
	run ; title ;

	proc sort data=_ttestsA ; by variable1 variable2 difference ; 
	proc sort data=_conflimitsA ; by variable1 variable2 difference  ; 
	proc sort data=_statisticsA ; by variable1 variable2 difference  ; 
	DATA _summaryA ;
		format Project $12. ;
		merge _ttestsA _conflimitsA _statisticsA ;
		by variable1 variable2 difference  ;
		Variable = Variable1 ;
	run ;

***** Save summary files to .csv ;
	PROC EXPORT DATA= _summaryA 
		outfile="Z:\groups\ECHO-Chicago\Data\Processed\RedCap\PrePostAll.Summary.csv" replace
		dbms=csv ;
		delimiter=',' ;
	run ;


* Test by project and cohort ;

ods output ttests=_ttestsB conflimits=_conflimitsB statistics=_statisticsB ;
	title ' By Project ' ;
	proc sort data=_prepost ; by project2 cohort ;
	proc TTEST DATA=_PREPOST plots=none;
		by project2 cohort ;
		paired PostSEAvg*PreSEAvg;
	run ; title ;

	proc sort data=_ttestsB ; by project2 cohort variable1 variable2 difference ; 
	proc sort data=_conflimitsB ; by project2 cohort variable1 variable2 difference  ; 
	proc sort data=_statisticsB ; by project2 cohort variable1 variable2 difference  ; 
	DATA _summaryB ;
		format Project $12. ;
		merge  _ttestsB _conflimitsB _statisticsB ;
		by project2 cohort variable1 variable2 difference  ;
		Variable = Variable1 ;
	run ;

***** Save summary files to .csv ;
	PROC EXPORT DATA= _summaryB 
		outfile="Z:\groups\ECHO-Chicago\Data\Processed\RedCap\PrePostAll.Cohort.Summary.csv" replace
		dbms=csv ;
		delimiter=',' ;
	run ;

/* Box plot ;

ods html path="e:/" ;

ods graphics on ;
PROC SORT data=_prepost; by project2 ;  RUN;
PROC BOXPLOT data=_prepost ;
	PLOT SEDiff*Project2;
run ;

ods html close ;

/*
PROC DATASETS lib=work ;
	delete  _: ;
run ;
*/
