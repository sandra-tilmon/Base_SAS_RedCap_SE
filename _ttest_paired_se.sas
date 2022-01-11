**********************************************************************;
* Project           : ECHO-Chicago
*
* Program name      : Test
*
* Author            : Sandra Tilmon
*
* Date created      : 9/14/2018
*
* Purpose           : Pilot code with asthma for pre/post analyses.
*					Goal is to create generalizable code based on the
*					data dictionaries.
*
* Revision History  :
*
* Date        Author      Ref    Revision (Date in YYYYMMDD format) 
*
**********************************************************************;

* Paired ttest ;
	ODS graphics on ;
	ods output ttests=_ttests conflimits=_conflimits statistics=_statistics ;* boxplot=boxplot;
	PROC TTEST data=&Project..RedPrePostWide plots(only)=box ;
		paired PostSEAvg*PreSEAvg     &SEPairedNames  ; *PostBEAvg*PreBEAvg PostEVAvg*PreEVAvg ;
	run ;

%put &SEPairedNames ;
* Create summary file from ttest results ;
	proc sort data=_ttests ; by variable1 variable2 difference ; 
	proc sort data=_conflimits ; by variable1 variable2 difference  ; 
	proc sort data=_statistics ; by variable1 variable2 difference  ; 
	DATA _summary ;
		format Project $12. ;
		merge _ttests _conflimits _statistics ;
		by variable1 variable2 difference  ;
		Project = "&Project." ;
		Variable = Variable1 ;
		var2=Variable2 ;
	run ;

	proc sort data=paireddict ; by var2 ;
	proc sort data=_summary ; by var2 ;

	DATA _summary2 ;
	merge _summary (in=_s) paireddict ;
	by var2 ;
	if _s;
	*drop prepost domain Variable1	Variable2
 LowerCLMean	UpperCLMean	StdDev	LowerCLStdDev	UpperCLStdDev	UMPULowerCLStdDev	UMPUUpperCLStdDev
 ; 
	run ;


	data &Project..Summary ; set _summary2 ; run ;

* Save summary file to .csv ;
	PROC EXPORT DATA= &Project..Summary
		outfile="Z:\groups\ECHO-Chicago\Data\Processed\Redcap\&project.\PrePost&Project..Summary.csv" replace
		dbms=csv ;
		delimiter=',' ;
	run ;

/* clean up ;
	PROC DATASETS lib=work ;
		delete  _: ;
	run ;
*/




* Paired ttest BY COHORT;
	proc sort data=&Project..RedPrePostWide ; by cohort ; run ;
	ODS graphics on ;
	ods output ttests=_ttcohort conflimits=_confcohort statistics=_statcohort ;* boxplot=boxplot;
	PROC TTEST data=&Project..RedPrePostWide plots(only)=box ;
		by cohort ;
		paired PostSEAvg*PreSEAvg     &SEPairedNames  ; *PostBEAvg*PreBEAvg PostEVAvg*PreEVAvg ;
	run ;
* Create summary file from ttest results ;
	proc sort data=_ttcohort ; by cohort variable1 variable2 difference  ; 
	proc sort data=_confcohort ; by cohort variable1 variable2 difference   ; 
	proc sort data=_statcohort ; by cohort variable1 variable2 difference   ; 
	DATA _cohort ;
		format Project $12. ;
		merge _ttcohort _confcohort _statcohort  ;
		by cohort variable1 variable2 difference  ;
		Project = "&Project." ;
		Variable = Variable1 ;
		var2=Variable2 ;
	run ;

	proc sort data=paireddict ; by var2 ;
	proc sort data=_cohort ; by var2 ;

	DATA _cohort2 ;
	merge _cohort (in=_c) paireddict ;
	by var2 ;
	if _c;
	*drop prepost domain Variable1	Variable2
 LowerCLMean	UpperCLMean	StdDev	LowerCLStdDev	UpperCLStdDev	UMPULowerCLStdDev	UMPUUpperCLStdDev
 ; 
	run ;


	data &Project..SummaryCohort ; set _cohort2 ; run ;

* Save summary file to .csv ;
	PROC EXPORT DATA= &Project..SummaryCohort
		outfile="Z:\groups\ECHO-Chicago\Data\Processed\Redcap\&project.\PrePost&Project..SummaryCohort.csv" replace
		dbms=csv ;
		delimiter=',' ;
	run ;


	

* OUTPUT MEANS for Patrick's reports ;

ods output Means.Summary=_means ;
PROC MEANS data=&Project..RedPrePostWide stackods ;
		var PreSEAvg &Prelist. PostSEAvg &Postlist. ;
	run ;

	PROC EXPORT DATA= _means
		outfile="Z:\groups\ECHO-Chicago\Data\Processed\Redcap\&project.\Averages.csv" replace
		dbms=csv ;
		delimiter=',' ;
	run ; 
/*
Name:       Summary
Label:      Summary statistics
Template:   base.summary
Path:       Means.Summary
	*/


* By cohort ;
	proc sort data=&Project..RedPrePostWide ; by cohort ; run ;
	ods output Summary=_class_means_ods ;
	PROC MEANS data=&Project..RedPrePostWide stackods ;
	by cohort ;
		var PreSEAvg &Prelist. PostSEAvg &Postlist. ;
		output out=_class_means mean= sum= /autoname;
	run ;


	PROC EXPORT DATA= _class_means_ods
		outfile="Z:\groups\ECHO-Chicago\Data\Processed\Redcap\&project.\AveragesCohort.csv" replace
		dbms=csv ;
		delimiter=',' ;
	run ; 
