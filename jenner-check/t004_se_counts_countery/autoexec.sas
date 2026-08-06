/* options obs=100; caps input rows for the captured run */
options obs=100 dlcreatedir;

/* The upstream script (_se_counts.sas) defines the %countery macro and
   calls it once per RedCap project (14 calls) against &project..redcap --
   raw survey export data that _import_redcap_data_and_dict.sas normally
   builds per project from a Z:\ network RedCap export -- then runs one
   PROC FREQ per project on redcap_event_name and stacks all 14 results.
   We keep the macro definition, every %countery() call, every PROC FREQ,
   and the final stacking DATA step byte-for-byte as written, and
   substitute one small mock <project>.redcap dataset per project (each
   with its own scratch subdirectory, since two same-named "redcap"
   members under different librefs pointing at one shared directory would
   collide) shaped like a RedCap export: a participant/record ID column, a
   redcap_event_name column, and the same pre/post timestamp-string column
   names each real %countery() call names as its Posttime/PreTime
   arguments. ADHDApr's timestamps are YYYY-MM-DD (the macro's own
   ADHDApr/Epilepsy branch parses with yymmdd10.); every other project's
   are MM/DD/YYYY (the macro's ELSE branch parses those with mmddyy10.). */

%let base = %sysfunc(pathname(work));

libname ADHDApr "&base./adhdapr";
libname ADHDOct "&base./adhdoct";
libname Adol    "&base./adol";
libname BHColl  "&base./bhcoll";
libname BHPsy   "&base./bhpsy";
libname CAT     "&base./cat";
libname CPA     "&base./cpa";
libname Geri    "&base./geri";
libname GeriSNF "&base./gerisnf";
libname HCV     "&base./hcv";
libname HTN     "&base./htn";
libname Obesity "&base./obesity";
libname Opiates "&base./opiates";
libname RBWH    "&base./rbwh";
libname SMI     "&base./smi";

data ADHDApr.redcap;
	length participant_id_i $10 redcap_event_name $20
		adhd_initial_survey_timestamp $20 adhd_post_survey_timestamp $20;
	Project = "ADHDApr";
	input participant_id_i $ redcap_event_name $ adhd_initial_survey_timestamp & $20. adhd_post_survey_timestamp & $20.;
	datalines;
P001 initial_arm_1 2019-01-15 10:30  2019-03-01 09:15
P002 initial_arm_1 2019-02-10 14:00  2019-04-05 11:45
;
run;

data ADHDOct.redcap;
	length participant_id_i $10 redcap_event_name $20
		adhd_initial_survey_timestamp $20 adhd_post_survey_timestamp $20;
	Project = "ADHDOct";
	input participant_id_i $ redcap_event_name $ adhd_initial_survey_timestamp & $20. adhd_post_survey_timestamp & $20.;
	datalines;
P101 initial_arm_1 10/05/2019 09:00  11/02/2019 10:00
;
run;

data Adol.redcap;
	length record_id $10 redcap_event_name $20
		adolescent_health_pr_v_0 $20 adolescent_health_po_v_2 $20;
	Project = "Adol";
	input record_id $ redcap_event_name $ adolescent_health_pr_v_0 & $20. adolescent_health_po_v_2 & $20.;
	datalines;
P201 initial_arm_1 06/01/2019 08:30  07/22/2019 09:30
;
run;

data BHColl.redcap;
	length record_id $10 redcap_event_name $20
		behavioral_health_in_v_0 $20 behavioral_health_in_v_2 $20;
	Project = "BHColl";
	input record_id $ redcap_event_name $ behavioral_health_in_v_0 & $20. behavioral_health_in_v_2 & $20.;
	datalines;
P301 initial_arm_1 08/09/2019 11:00  09/01/2019 12:00
;
run;

data BHPsy.redcap;
	length record_id $10 redcap_event_name $20
		preseries_survey_timestamp $20 postseries_survey_timestamp $20;
	Project = "BHPsy";
	input record_id $ redcap_event_name $ preseries_survey_timestamp & $20. postseries_survey_timestamp & $20.;
	datalines;
P401 initial_arm_1 05/01/2019 10:00  06/15/2019 11:00
;
run;

data CAT.redcap;
	length record_id $10 redcap_event_name $20
		childhood_adversity__v_0 $20 childhood_adversity__v_2 $20;
	Project = "CAT";
	input record_id $ redcap_event_name $ childhood_adversity__v_0 & $20. childhood_adversity__v_2 & $20.;
	datalines;
P501 initial_arm_1 09/30/2019 13:00  10/20/2019 14:00
;
run;

data CPA.redcap;
	length participant_id_i $10 redcap_event_name $20
		complex_pediatric_as_v_0 $20 complex_pediatric_as_v_2 $20;
	Project = "CPA";
	input participant_id_i $ redcap_event_name $ complex_pediatric_as_v_0 & $20. complex_pediatric_as_v_2 & $20.;
	datalines;
P601 initial_arm_1 10/11/2019 09:00  11/01/2019 10:00
;
run;

data Geri.redcap;
	length record_id $10 redcap_event_name $20
		geriatrics_survey_timestamp $20 geriatrics_postserie_v_0 $20;
	Project = "Geri";
	input record_id $ redcap_event_name $ geriatrics_survey_timestamp & $20. geriatrics_postserie_v_0 & $20.;
	datalines;
P701 initial_arm_1 04/01/2019 08:00  05/15/2019 09:00
;
run;

data GeriSNF.redcap;
	length record_id $10 redcap_event_name $20
		geriatrics_survey_timestamp $20 geriatrics_postserie_v_0 $20;
	Project = "GeriSNF";
	input record_id $ redcap_event_name $ geriatrics_survey_timestamp & $20. geriatrics_postserie_v_0 & $20.;
	datalines;
P801 initial_arm_1 04/10/2019 08:00  05/20/2019 09:00
;
run;

data HCV.redcap;
	length record_id_i $10 redcap_event_name $20
		hep_c_preseries_surv_v_0 $20 hep_c_postseries_sur_v_2 $20;
	Project = "HCV";
	input record_id_i $ redcap_event_name $ hep_c_preseries_surv_v_0 & $20. hep_c_postseries_sur_v_2 & $20.;
	datalines;
P901 initial_arm_1 07/01/2019 08:00  08/01/2019 09:00
;
run;

data HTN.redcap;
	length participant_id_i $10 redcap_event_name $20
		htn_preseries_survey_timestamp $20 htn_postseries_surve_v_0 $20;
	Project = "HTN";
	input participant_id_i $ redcap_event_name $ htn_preseries_survey_timestamp & $20. htn_postseries_surve_v_0 & $20.;
	datalines;
P1001 initial_arm_1 09/20/2019 08:00  10/02/2019 09:00
;
run;

data Obesity.redcap;
	length participant_id_i $10 redcap_event_name $20
		childhood_obesity_in_v_0 $20 childhood_obesity_po_v_2 $20;
	Project = "Obesity";
	input participant_id_i $ redcap_event_name $ childhood_obesity_in_v_0 & $20. childhood_obesity_po_v_2 & $20.;
	datalines;
P1101 initial_arm_1 08/14/2019 08:00  09/01/2019 09:00
;
run;

data Opiates.redcap;
	length participant_id_i $10 redcap_event_name $20
		oud_preseries_survey_timestamp $20 oud_postseries_surve_v_0 $20;
	Project = "Opiates";
	input participant_id_i $ redcap_event_name $ oud_preseries_survey_timestamp & $20. oud_postseries_surve_v_0 & $20.;
	datalines;
P1201 initial_arm_1 09/05/2019 08:00  10/05/2019 09:00
;
run;

data RBWH.redcap;
	length participant_id_i $10 redcap_event_name $20
		riskbased_approach_t_v_0 $20 riskbased_approach_t_v_2 $20;
	Project = "RBWH";
	input participant_id_i $ redcap_event_name $ riskbased_approach_t_v_0 & $20. riskbased_approach_t_v_2 & $20.;
	datalines;
P1301 initial_arm_1 03/01/2019 08:00  04/01/2019 09:00
;
run;

data SMI.redcap;
	length record_id $10 redcap_event_name $20
		serious_mental_illne_v_0 $20 serious_mental_illne_v_2 $20;
	Project = "SMI";
	input record_id $ redcap_event_name $ serious_mental_illne_v_0 & $20. serious_mental_illne_v_2 & $20.;
	datalines;
P1401 initial_arm_1 02/01/2019 08:00  03/15/2019 09:00
;
run;
