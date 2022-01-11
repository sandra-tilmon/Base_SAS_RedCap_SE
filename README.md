# Base_SAS_RedCap_SE
Process pre/post surveys by clinical area in base SAS (not Enterprise Guide).

Surveys are collected in RedCap.

This program uses each series' data dictionary to set relevant questions' Pre or Post survey status and their Domain: Self-efficacy, Behavior, or Evaluation.

echomaster.csv also sets variable name cleaning parameters, the SAS import program, folder names, and standardizes names for ID and timestamp variables.


1. First place an X in column A of echomaster.csv for the series you'd like to run. Save and close.
2. Open ECHO RedCAP Master.sas
   A. Bring in ECHO master file
   B. Set libraries
   C. Import redcap data and data dictionary
   D. Create macro variables
   E. Create pre/post datasets
   F. Do a paired t-test and output
