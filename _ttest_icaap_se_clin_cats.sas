*********************************
* Basis for ICAAP 2020 poster ;
*********************************;

DATA icaap.clinicalskills ;
	set adhdapr.CLINICALSKILLS
		adhdoct.Clinicalskills
		adol.clinicalskills
		cat.clinicalskills
		cpa.clinicalskills
		obesity.clinicalskills ;

run ;

* Overall ;
	
proc means data=icaap.clinicalskills ;
	var PostClinAvg PreClinAvg PostKnowAvg PreKnowAvg PostProcAvg PreProcAvg ;
run ;

	title ' Overall ' ;
	proc TTEST DATA=icaap.clinicalskills;
		paired PostClinAvg*PreClinAvg PostKnowAvg*PreKnowAvg PostProcAvg*PreProcAvg ; 
	run ; title ;
