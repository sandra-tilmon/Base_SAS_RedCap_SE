**********************************************************************;
* Project           : ECHO-Chicago
*
* Program name      : Credentials
*
* Author            : Sandra Tilmon
*
* Date created      : 12/03/2019
*
* Purpose           : Collect credentials and assign categories, test SE
*
* Revision History  :
*
* Date        Author      Ref    Revision (Date in YYYYMMDD format) 
*
**********************************************************************;

proc format ;
	value YesNo
		1 = " Yes"
		0 = "No" ;
	run ;



libname redcap 'Z:\groups\ECHO-Chicago\Data\Raw\RedCap' ;

DATA redcap.credential ;
*length Project Project2 $12. ;
set 
		ADHDAPR.Credential 
		ADHDOCT.Credential 
		ADOL.credential 
		BHCOLL.Credential 
		BHPSY.Credential 
		CAT.Credential 
		CPA.Credential 
		EPILEPSY.Credential 
		GERI.Credential 
		GERISNF.Credential 
		HCV.Credential 
		HTN.Credential 
		OBESITY.Credential 
		OPIATES.Credential 
		RBWH.credential 
		SMI.Credential 
;
format credential ;
run ;
/*PROC FREQ data=redcap.credential ;
	table Project Credentialtxt / list missing nopercent nocum ;
	table Project*Credentialtxt / list missing nopercent nocum ;
run ;
*/

* Import categorization ;

	proc import datafile="Z:\groups\ECHO-Chicago\Research\SE\2019-12-03_prescribing_provider.csv"
            dbms=csv
            out=provcat
            replace;
     delimiter=',';
     getnames=yes;
run;

* Join to IDs by credential ;

proc sort data=redcap.credential ; by Credentialtxt ; 
proc sort data=provcat ; by Credentialtxt ; run ;
DATA redcap.credentialscat ;
	merge redcap.credential provcat ;
	by Credentialtxt ;
	if Credentialtxt = 'Registered Dietician/Nutritionis' then DO ;
		Prescriber = 0 ; Medical = 0 ; Behavioral = 0 ;
	end ;
	if IDvar = ' ' then DELETE ;
run ;

PROC FREQ data=redcap.credentialscat ;
	table Project Credentialtxt / list missing nopercent nocum ;
	table Project*Credentialtxt / list missing nopercent nocum ;
run ;

***** Save credentialscat to .csv ;
	PROC EXPORT DATA= redcap.credentialscat
		outfile="Z:\groups\ECHO-Chicago\Research\SE\CredentialsCat.csv" replace
		dbms=csv ;
		delimiter=',' ;
	run ;

* Join to redcap ;

PROC SORT data=redcap.CREDENTIALSCAT ; by id ;
PROC SORT data=redcap.prepost_widemin ; by id ; run ;
DATA redcap.redprepostwideminCAT ;
	merge redcap.CREDENTIALSCAT (in=_cred) redcap.prepost_widemin (in=_red) ;
	by id ;
	if _red ;
	c = _cred ; r=_red ;
run ;


* Paired ttest BY prescriber status ;
	proc sort data=redcap.redprepostwideminCAT ; by Prescriber ; run ;


	ODS graphics on ;
	PROC TTEST data=redcap.redprepostwideminCAT  plots(only)=box;
		class Prescriber ;
		var SEDiff ; 
		format Prescriber YesNo. ;
	run ;

	ods output ttests=_ttpres conflimits=_confpres statistics=_statpres ;* boxplot=boxplot;
	PROC TTEST data=redcap.redprepostwideminCAT  plots(only)=box ;
		by Prescriber ;
		paired PostSEAvg*PreSEAvg    ; 
	run ;


* Create summary file from ttest results ;
	proc sort data=_ttpres ; by prescriber variable1 variable2 difference  ; 
	proc sort data=_confpres ; by prescriber variable1 variable2 difference   ; 
	proc sort data=_statpres ; by prescriber variable1 variable2 difference   ; 
	DATA _prescriber;
		format Project $12. ;
		merge _ttpres _confpres _statpres  ;
		by prescriber variable1 variable2 difference  ;
		Variable = Variable1 ;
		var2=Variable2 ;
	run ;

	data redcap.summaryPrescriber ; set _prescriber; run ;


* Save summary file to .csv ;
	PROC EXPORT DATA=  redcap.summaryPrescriber
		outfile="Z:\groups\ECHO-Chicago\Research\SE\PrePostAll.Prescriber.Summary.csv" replace
		dbms=csv ;
		delimiter=',' ;
	run ;
