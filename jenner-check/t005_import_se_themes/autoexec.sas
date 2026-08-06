/* options obs=100; caps input rows for the captured run */
options obs=100;

/* The upstream script (_import_se_themes_clin_cats.sas) reads a fixed-width
   column CSV of survey-question themes from a hardcoded network path
   (Z:\groups\ECHO-Chicago\Research\SE\SE questions_2020-07-27.csv) into a
   `se` libname. We point `se` at a scratch libname and redirect the INFILE
   statement (the only line touched) from that network path to inline
   DATALINES carrying the same 8 columns (Project, Variable, var2, Theme,
   Lesser_themes, CSDomain, CSComponent, Text) for a few of this repo's own
   project codes (ADHDApr, Adol, CPA), so the script's own informat/format
   declarations and column layout run completely unmodified. */

libname se "%sysfunc(pathname(work))";
