/* options obs=100; caps input rows for the captured run */
options obs=100;

/* The upstream script (_datasets_se_clin_cats.sas) reads &Project..RedPrePostWide
   (built earlier in the pipeline by _datasets_prepost_se.sas from a RedCap
   export at a Z:\ network path) plus a set of comma-separated survey-item
   macro variables (&PreCommc., &PostCommc., ... one per clinical-skill
   domain/component) that _macro_vars_clin_cats.sas normally derives via
   PROC SQL from a network-hosted "SE questions" catalog. We substitute a
   small mock RedPrePostWide with two pre/post item columns per domain
   (comm/exam/treat/clin/know/proc), point &Project. at a scratch libname,
   and set the six macro-variable lists directly to the matching column
   names -- the same lists _macro_vars_clin_cats.sas would have produced --
   so the script's own mean()-based averaging and its "not all projects
   have procedure questions" branch run completely unmodified. */

%let Project = DEMO;
libname demo "%sysfunc(pathname(work))";

%let PreCommc  = comm_pre1, comm_pre2;
%let PostCommc = comm_post1, comm_post2;
%let PreExamc  = exam_pre1, exam_pre2;
%let PostExamc = exam_post1, exam_post2;
%let PreTreatc = treat_pre1, treat_pre2;
%let PostTreatc = treat_post1, treat_post2;
%let PreClinc  = clin_pre1, clin_pre2;
%let PostClinc = clin_post1, clin_post2;
%let PreKnowc  = know_pre1, know_pre2;
%let PostKnowc = know_post1, know_post2;
%let PreProcc  = proc_pre1, proc_pre2;
%let PostProcc = proc_post1, proc_post2;

data demo.RedPrePostWide;
	length IDvar $10 Project $8 Credentialtxt $20;
	format Timestamp PostTimeStamp date9.;
	input IDvar $ Project $ Cohort Credentialtxt $ PracYears PastPart Timestamp :mmddyy10. PostTimeStamp :mmddyy10.
		comm_pre1 comm_pre2 comm_post1 comm_post2
		exam_pre1 exam_pre2 exam_post1 exam_post2
		treat_pre1 treat_pre2 treat_post1 treat_post2
		clin_pre1 clin_pre2 clin_post1 clin_post2
		know_pre1 know_pre2 know_post1 know_post2
		proc_pre1 proc_pre2 proc_post1 proc_post2;
	datalines;
P001 DEMO 1 MD 3 1 01/15/2019 03/01/2019 2 3 4 4 2 2 4 3 3 2 4 4 2 3 4 4 2 3 4 4
P002 DEMO 1 RN 6 0 02/10/2019 04/05/2019 3 2 4 3 2 3 3 4 2 2 3 4 3 3 4 3 2 2 3 4
P003 DEMO 2 MD 2 1 03/05/2019 05/10/2019 2 2 3 4 3 2 4 4 2 3 3 3 2 2 3 4 2 2 4 3
;
run;
