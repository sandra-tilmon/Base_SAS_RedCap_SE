/* options obs=100; caps input rows for the captured run */
options obs=100 dlcreatedir;

/* The upstream script (_datasets_stack_se.sas) stacks se_themes datasets
   from 13 separate project libnames (adhdapr, adhdoct, adol, cpa, cat,
   diabetes, geri, gerisnf, hcv, htn, obesity, opiates, rbwh, smi), each
   pointed at Z:\groups\ECHO-Chicago\Research\SE\Datasets\<project> per
   _libraries_se.sas, and writes results to a `se` libname pointed at the
   same network share. We substitute one mock se_themes-shaped dataset per
   project (idvar/id, PrePost, theme, answer -- one Pre and one Post row per
   participant per theme, the shape the script's own `if PrePost = 'Pre'`
   / `if PrePost = 'Post'` split and pre/post merge-by-ID logic expects).
   Each project gets its OWN scratch subdirectory (not a shared one) so
   same-named "se_themes" members under different librefs stay physically
   distinct, matching how the real network-share layout keeps one folder
   per project. se.* is pointed at its own scratch subdirectory too, in
   place of the network research share. */

%let base = %sysfunc(pathname(work));

libname se       "&base./se";
libname adhdapr  "&base./adhdapr";
libname adhdoct  "&base./adhdoct";
libname adol     "&base./adol";
libname cpa      "&base./cpa";
libname cat      "&base./cat";
libname diabetes "&base./diabetes";
libname geri     "&base./geri";
libname gerisnf  "&base./gerisnf";
libname hcv      "&base./hcv";
libname htn      "&base./htn";
libname obesity  "&base./obesity";
libname opiates  "&base./opiates";
libname rbwh     "&base./rbwh";
libname smi      "&base./smi";

data adhdapr.se_themes;
	length project $8 idvar $10 PrePost $4 theme $32;
	input project $ idvar $ PrePost $ theme & $32. answer;
	datalines;
adhdapr P001 Pre  Confidence  2
adhdapr P001 Post  Confidence  4
adhdapr P002 Pre  Confidence  3
adhdapr P002 Post  Confidence  4
;
run;

data adhdoct.se_themes;
	length project $8 idvar $10 PrePost $4 theme $32;
	input project $ idvar $ PrePost $ theme & $32. answer;
	datalines;
adhdoct P003 Pre  Confidence  2
adhdoct P003 Post  Confidence  3
;
run;

data adol.se_themes;
	length project $8 idvar $10 PrePost $4 theme $32;
	input project $ idvar $ PrePost $ theme & $32. answer;
	datalines;
adol P004 Pre  Clinical skill - sensitive -  3
adol P004 Post  Clinical skill - sensitive -  4
;
run;

data cpa.se_themes;
	length project $8 idvar $10 PrePost $4 theme $32;
	input project $ idvar $ PrePost $ theme & $32. answer;
	datalines;
cpa P005 Pre  Communication  2
cpa P005 Post  Communication  4
;
run;

data cat.se_themes;      set adhdapr.se_themes(obs=0);  run;
data diabetes.se_themes; set adhdapr.se_themes(obs=0);  run;
data geri.se_themes;     set adhdapr.se_themes(obs=0);  run;
data gerisnf.se_themes;  set adhdapr.se_themes(obs=0);  run;
data hcv.se_themes;      set adhdapr.se_themes(obs=0);  run;
data htn.se_themes;      set adhdapr.se_themes(obs=0);  run;
data obesity.se_themes;  set adhdapr.se_themes(obs=0);  run;
data opiates.se_themes;  set adhdapr.se_themes(obs=0);  run;
data rbwh.se_themes;     set adhdapr.se_themes(obs=0);  run;
data smi.se_themes;      set adhdapr.se_themes(obs=0);  run;
