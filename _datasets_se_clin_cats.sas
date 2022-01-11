***********************************************
* Clinical skill categories datasets ;
***********************************************;

DATA &Project..ClinicalSkills ;
	set &Project..RedPrePostWide;
* CS Domain ;
	PreCommAvg = mean(&PreCommc.) ;
		PostCommAvg = mean(&PostCommc.) ;
	PreExamAvg = mean(&PreExamc.) ;
		PostExamAvg = mean(&PostExamc.) ;
	PreTreatAvg = mean(&PreTreatc.) ;
		PostTreatAvg = mean(&PostTreatc.) ;
* CS Component ;
	PreClinAvg = mean(&PreClinc.) ;
		PostClinAvg = mean(&PostClinc.) ;
	PreKnowAvg = mean(&PreKnowc.) ;
		PostKnowAvg = mean(&PostKnowc.) ;

	* not all projects have procedure questions ;
	PreProcAvg = . ; 
		PostProcAvg = . ;
	if Project ne "ADHDApr" THEN DO ;
		PreProcAvg = mean(&PreProcc.) ;
				PostProcAvg = mean(&PostProcc.) ;
	end ;
	keep IDvar Project Cohort Credentialtxt PracYears PastPart Timestamp PostTimeStamp PreCommAvg PostCommAvg PreExamAvg PostExamAvg PreTreatAvg PostTreatAvg 
			PreClinAvg PostClinAvg PreKnowAvg PostKnowAvg PreProcAvg  PostProcAvg ;
run ;
