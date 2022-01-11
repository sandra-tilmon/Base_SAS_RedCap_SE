**********************************************************************;
* Project           : ECHO-Chicago
*
* Program name      : Master Control
*
* Author            : Sandra Tilmon
*
* Date created      : 9/21/2018
*
* Purpose           : Master control -- bring in excel file? Based on NORC MCBS Reporting Machine
*
* Revision History  :
*
* Date        Author      Ref    Revision (Date in YYYYMMDD format) 
*
**********************************************************************;

********************************************************************************************;
* Import main control file																	;
********************************************************************************************;

* NOTE: localized 64 bit incompatible SAS/Excel import error, so importing .csv ;

	proc import datafile="Z:\groups\ECHO-Chicago\Data\SAS Code\echomaster.csv"
            dbms=csv
            out=control
            replace;
     delimiter=',';
     getnames=yes;

run;

********************************************************************************************;
* Limit to tables marked to be run, establish run order for loopy (not set up yet)							;
********************************************************************************************;
	DATA controlx ; 
		set control  ;
		*X_to_run_table=upcase(RunMe);
		if trim(left(upcase(RunMe))) eq 'X';
		RunOrder = _n_ ;
	run ;

	data _null_;
  		set controlx nobs=nobs;
	  		call symput('n_controlx',strip(put(nobs,18.)));
			call symputx('Project', Project) ;
			call symputx('Dict', Dict) ;
			call symputx('SASProg', SASProg) ;
			call symputx('RawData', RawData) ;
			call symputx('PreNc', PreNc) ;
			call symputx('PostNc', PostNc) ;
			call symputx('PreTime', PreTime) ;
			call symputx('PostTime', PostTime);
			call symputx('IDVAR', IDVAR) ;
	run ;

%let path = Z:\groups\ECHO-Chicago\Data\Raw\RedCap\&Project.\ ;
%put &path ;

%let includery = &path.&sasprog. ;
%put &includery ;

libname &Project "Z:\groups\ECHO-Chicago\Data\Raw\RedCap\&Project." ;

%put Z:\groups\ECHO-Chicago\Data\Raw\RedCap\&Project.\&dict. ;

%put &sysdate. ;


