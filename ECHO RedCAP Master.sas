**********************************************************************;
* Project           : ECHO-Chicago Master PrePost SE
*
* Program name      : External control file
*
* Author            : Sandra Tilmon
*
* Date created      : 2/20/2020
*
* Purpose           : Master file calls other, modular functions
*
* Revision History  :
*
* Date        		Author      Ref		Revision (Date in YYYYMMDD format) 
* 02/20/2020		S Tilmon	1		Moved out of Enterprise Guide for modular fun time
* 12/16/2021		S Tilmon	2		Work on bugs so others can run this
*
**********************************************************************;

* Bring in ECHO master file ;

	%include 'Z:\groups\ECHO-Chicago\Data\SAS Code\programs\_import_echo_master.sas' ;

* Set libraries ;

	%include 'Z:\groups\ECHO-Chicago\Data\SAS Code\programs\_libraries_data_raw.sas' ;

* Import redcap data and data dictionary ;

	%include 'Z:\groups\ECHO-Chicago\Data\SAS Code\programs\_import_redcap_data_and_dict.sas' ;

* Create macro variables ;

	%include 'Z:\groups\ECHO-Chicago\Data\SAS Code\programs\_macro_vars_se.sas' ;

* Create pre/post dataset ;

	%include 'Z:\groups\ECHO-Chicago\Data\SAS Code\programs\_datasets_prepost_se.sas' ;

* Paired t-test pre/post ;
	* This series ;
	%include 'Z:\groups\ECHO-Chicago\Data\SAS Code\programs\_ttest_paired_se.sas' ;

	* All series ;
	%include 'Z:\groups\ECHO-Chicago\Data\SAS Code\programs\_ttest_all_series_paired_se.sas' ;
