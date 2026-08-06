
* CLEAN TIMESTAMP VARIABLES ;
%macro countery(Project, Posttime, PreTime, IDvar) ;

DATA &project..redcap2 ;
	set &project..redcap ;
	If Project in ('ADHDApr',    'Epilepsy' ) then DO ;

		if &Pretime ne ' ' then DO ;
			_prefindsp = index(&Pretime, ' ') ;

			_predt = substr(&Pretime,1,_prefindsp) ;

			PreDate = input(_predt,yymmdd10.) ;
		end ;

		if &Posttime ne ' ' then DO ;
			_postfindsp = index(&Posttime, ' ') ;

			_postdt = substr(&Posttime,1,_postfindsp) ;

			PostDate = input(_postdt,yymmdd10.) ;
		end ;
	end ;

	ELSE If Project in ('ADHDOct', 'Adol', 'BHColl', 'BHPsy', 'CAT', 'CompCare', 'CompCar2', 'CPA',
		'Geri',  'GeriSNF',  'HCV', 'HCVmgmt',   'HTN',  'Obesity', 'Opiates', 'RBWH', 'SMI') then DO ;

		if &Pretime ne ' ' then DO ;
			_prefindsp = index(&Pretime, ' ') ;

			_predt = substr(&Pretime,1,_prefindsp) ;

			PreDate = input(_predt,mmddyy10.) ;
		end ;

		if &Posttime ne ' ' then DO ;
			_postfindsp = index(&Posttime, ' ') ;

			_postdt = substr(&Posttime,1,_postfindsp) ;

			PostDate = input(_postdt,mmddyy10.) ;
		end ;
	end ;

	IDVAR = &IDvar. ;
	format _all_ ;
	format PREDATE POSTDATE date9. ;
	drop _:  &Posttime. &IDvar. ;
run ;


DATA _include ;
	set &project..redcap2 ;

	if PostDate = . then DELETE ; 
	if PostDate > '21NOV2019'd then DELETE ;

	keep Project IDvar PostDate ;
run ;

proc sort data= _include ; by IDvar ;
proc sort data= &project..redcap2 ; by IDvar ;

DATA &project..redcap3 ;
	merge &project..redcap2 (in=_r) _include (in=_i) ;
	by IDvar ;
	if _i ;
run ;

%mend countery ;

%countery(ADHDApr,	adhd_post_survey_timestamp,	adhd_initial_survey_timestamp, participant_id_i) ;
%countery(ADHDOct,	adhd_post_survey_timestamp, adhd_initial_survey_timestamp,	participant_id_i) ;
%countery(Adol,	adolescent_health_po_v_2,	adolescent_health_pr_v_0, record_id) ;

%countery(BHColl,	behavioral_health_in_v_2,	behavioral_health_in_v_0, record_id) ;
%countery(BHPsy,	postseries_survey_timestamp,	preseries_survey_timestamp, record_id) ;
%countery(CAT,	childhood_adversity__v_2,	childhood_adversity__v_0, record_id) ;

%countery(CPA,	complex_pediatric_as_v_2,	complex_pediatric_as_v_0, participant_id_i) ;

%countery(Geri,	geriatrics_postserie_v_0,	geriatrics_survey_timestamp, record_id) ;
%countery(GeriSNF,	geriatrics_postserie_v_0,	geriatrics_survey_timestamp, record_id) ;
%countery(HCV,	hep_c_postseries_sur_v_2,	hep_c_preseries_surv_v_0, record_id_i) ;

%countery(HTN,	htn_postseries_surve_v_0,	htn_preseries_survey_timestamp, participant_id_i) ;
%countery(Obesity,	childhood_obesity_po_v_2,	childhood_obesity_in_v_0, participant_id_i) ;
%countery(Opiates,	oud_postseries_surve_v_0,	oud_preseries_survey_timestamp, participant_id_i) ;
%countery(RBWH,	riskbased_approach_t_v_2,	riskbased_approach_t_v_0, 	participant_id_i) ;
%countery(SMI,	serious_mental_illne_v_2,	serious_mental_illne_v_0, record_id) ;









proc freq data=adhdapr.redcap3 ;
	tables redcap_event_name / list missing out=adhdapr;
run ;

proc freq data=adhdoct.redcap3 ;
	tables redcap_event_name / list missing out=adhdoct;
run ;

proc freq data=adol.redcap3 ;
	tables redcap_event_name / list missing out=adol;
run ;

proc freq data=bhcoll.redcap3 ;
	tables redcap_event_name / list missing out=bhcoll;
run ;

proc freq data=bhpsy.redcap3 ;
	tables redcap_event_name / list missing out=bhpsy;
run ;

proc freq data=cat.redcap3 ;
	tables redcap_event_name / list missing out=cat;
run ;

proc freq data=cpa.redcap3 ;
	tables redcap_event_name / list missing out=cpa;
run ;

proc freq data=geri.redcap3 ;
	tables redcap_event_name / list missing out=geri;
run ;

proc freq data=gerisnf.redcap3 ;
	tables redcap_event_name / list missing out=gerisnf;
run ;

proc freq data=hcv.redcap3 ;
	tables redcap_event_name / list missing out=hcv;
run ;

proc freq data=htn.redcap3 ;
	tables redcap_event_name / list missing out=htn;
run ;

proc freq data=obesity.redcap3 ;
	tables redcap_event_name / list missing out=obesity;
run ;

proc freq data=opiates.redcap3 ;
	tables redcap_event_name / list missing out=opiates ;
run ;

proc freq data=rbwh.redcap3 ;
	tables redcap_event_name / list missing out=rbwh ;
run ;

proc freq data=smi.redcap3 ;
	tables redcap_event_name / list missing out=smi ;
run ;


* -- ;
DATA counts ;
	set adhdapr adhdoct adol bhcoll bhpsy cat cpa geri gerisnf hcv htn obesity opiates rbwh smi ;
run ;


proc print data=counts ; run ;
