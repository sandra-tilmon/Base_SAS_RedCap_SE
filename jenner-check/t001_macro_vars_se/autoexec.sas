/* options obs=100; caps input rows for the captured run */
options obs=100;

/* The upstream script (_macro_vars_se.sas) reads its data dictionary from
   work.dict&Project. -- built upstream by _import_redcap_data_and_dict.sas
   from a RedCap-exported tab file at a hardcoded Z:\ path. We substitute a
   small mock dictionary with the same PRE/POST naming convention the real
   script depends on (PreNc/PostNc = the trailing-suffix length trimmed off
   each variable name to compute Var2), and point &Project. at a scratch
   libname instead of a network share so &Project..PairedDict lands somewhere
   real. */

%let Project = DEMO;
%let PreNc = 4;   /* trims trailing "_pre" */
%let PostNc = 5;  /* trims trailing "_post" */

libname demo "%sysfunc(pathname(work))";

data work.dictDEMO;
	length Variable $31 PrePost $6 Domain $18 Theme $32 Field_Label $60;
	input Variable $ PrePost $ Domain $ Theme $ Field_Label $60.;
	datalines;
q1_pre Pre SE Confidence How_confident_are_you_pre
q2_pre Pre SE Confidence How_confident_are_you_pre_2
q3_pre Pre EVALUATION Usefulness How_useful_was_this_pre
q1_post Post SE Confidence How_confident_are_you_post
q2_post Post SE Confidence How_confident_are_you_post_2
q3_post Post EVALUATION Usefulness How_useful_was_this_post
;
run;
