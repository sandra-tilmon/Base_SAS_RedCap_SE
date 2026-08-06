/* options obs=100; caps input rows for the captured run */
options obs=100;

/* The upstream script (_import_credentials.sas) imports a provider
   credentials CSV from a hardcoded network path
   (Z:\groups\ECHO-Chicago\Research\SE\CredentialsCat.csv, itself the
   output of _credentials.sas's own PROC EXPORT) into SE.Credentials, then
   sorts and merges it by ID against SE.prepostwide (built earlier by
   _datasets_stack_se.sas). We point `se` at a scratch libname, and build a
   small mock SE.prepostwide with matching "project,idvar"-style ID values
   (the exact composite-key convention _datasets_stack_se.sas's own
   `catx(',', Project2, idvar)` produces) so the script's own drop, sort,
   and merge run against real matching keys on both sides. The PROC IMPORT
   step itself is replaced with an equivalent inline-DATALINES DATA step
   producing the same SE.Credentials columns/rows a CSV import would --
   the hosted runner's script.sas + autoexec.sas submission has no channel
   for uploading a companion CSV, so PROC IMPORT's file dependency can't be
   exercised standalone; the drop/sort/merge logic that follows it runs
   completely unmodified. */

libname se "%sysfunc(pathname(work))";

data se.prepostwide;
	length id $12 theme $32;
	input id $ theme & $32. pre post;
	datalines;
adhd,P001 Confidence  2 4
adhd,P002 Confidence  3 4
adol,P004 Screening  3 4
;
run;
