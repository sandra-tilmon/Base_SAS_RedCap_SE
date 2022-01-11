* Make pre/post paired datasets ;

* CLEAN TIMESTAMP VARIABLES ;
DATA _redcap2 ;
	set redcap ;

if Project = 'SSALC' then cohort = '1' ;

	If Project in ('ADHDApr',  'Epilepsy', 'OUDOlder') then DO ;

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

	ELSE If Project in ('ADHDOct', 'Adol', 'BHColl', 'BHPsy', 'CAT', 'CompCare', 'CompCar2', 'CPA', 'CPACare', 'Diabetes',
		'Geri',  'GeriSNF',  'HCV', 'HCVEthic', 'HCVmgmt',   'HTN',  'Obesity', 'OUDED', 'Opiates', 'RBWH', 'SMI', 'SSALC') then DO ;

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

	* CPACare workaround for an incomplete pre-survey ;
	if Project = 'CPACare' and strip(record_id) = '6' then DO ;
		PreDate = '15OCT2020'd ;
	end ;

	IDVAR = &IDvar. ;
	format _all_ ;
	format PREDATE POSTDATE date9. ;
	drop _: &Pretime. &Posttime. &IDvar. ;
run ;

**********************************************************************;		
* Create presurvey ;
**********************************************************************;

PROC SQL ;
	CREATE TABLE _RedPre as 
	SELECT IDVAR , 'Pre' as PrePost, PreDate as TimeStamp, cohort,
		&PreListc
	from _RedCap2 
	where PreDate is not null ;
quit ;

* Calculations ;
DATA _RedPre ;
	set _RedPre ;
	format PreSEAvg ;* PreEVAvg 4.2 ; *PreBEAvg;
	PreSESum = sum(&PreSEc) ;
*	PreBESum = sum(&PreBEc) ;
*	PreEVSum = sum(&PreEVc) ;
* For BHPsy and SMI ;
*	PreS1Sum = sum(&PreS1c) ;

	PreSEAvg = PreSESum / &N_SE ;
*	PreBEAvg = PreBESum / &N_BE ;
*	PreEVAvg = PreEVSum / &N_EV ;
* For BHPsy and SMI ;
*	PreS1Avg = PreS1Sum / &N_S1 ;
run ;

* Rename vars for long ;
DATA _RedPre2 ;
	set _redpre (rename=(&prenames. PreSESum = SESum PreSEAvg = SEAvg 
	 ));* PreEVSum = EVSum PreEVAvg = EVAvg PreBESum = BESum PreBEAvg = BEAvg ));  
	*PreS1Sum = S1Sum PreS1Avg = S1Avg)) ; * For BHPsy and SMI ;
run ;

**********************************************************************;
* Create postsurvey ;
**********************************************************************;

PROC SQL ;
	CREATE TABLE _RedPost as 
	SELECT IDVAR, 'Post' as PrePost, PostDate as TimeStamp,
		&PostListc
	from _RedCap2 
 	where  PostDate is not null ;
quit ;

* Calculations ;
DATA _RedPost ;
	set _RedPost ;
	format PostSEAvg 4.2 PostBEAvg PostEVAvg 4.2 ;
	PostSESum = sum(&PostSEc) ;
*	PostBESum = sum(&PostBEc) ;
*	PostEVSum = sum(&PostEVc) ;
* For BHPsy and SMI ;
*	PostS1Sum = sum(&PostS1c) ;


	PostSEAvg = PostSESum / &N_SE ;
*	PostBEAvg = PostBESum / &N_BE ;
*	PostEVAvg = PostEVSum / &N_EV ;
* For BHPsy and SMI ;
*	PostS1Avg = PostS1Sum / &N_S1 ;
run ;

* Rename vars for long ;
DATA _RedPost2 ; 
	set _redpost (rename=(&postnames. PostSESum = SESum PostSEAvg = SEAvg   ));
	*  PostEVSum = EVSum PostEVAvg = EVAvg PostBESum = BESum PostBEAvg = BEAvg )) ; 
	* PostS1Sum = S1Sum PostS1Avg = S1Avg)) ; * For BHPsy and SMI ;
run ;

**********************************************************************;
* Merge pre/post ;
**********************************************************************;

* Merge wide (different varnames) ONLY if there are pre and post ;
proc sort data=_redpre ; by IDVAR ;
proc sort data=_redpost ; by IDVAR ;

DATA _RedPrePostWide ;
	merge _redpre (in=_pre drop=PrePost) 
		_redpost (in=_post drop=PrePost rename=(Timestamp=PostTimestamp)) ;
	by IDVAR ;
	pre=_pre ; post=_post ;
	if _pre and _post ;
	Project = "&Project." ;
run ;

DATA &Project..RedCapWideFull ;
	merge _redpre (in=_pre drop=PrePost) 
		_redpost (in=_post drop=PrePost rename=(Timestamp=PostTimestamp)) ;
	by IDVAR ;
	pre=_pre ; post=_post ;
*	if _pre and _post ;
	Project = "&Project." ;
run ;

***** Save wide  datset ;
DATA &Project..RedPrePostWide ;
	set _redprepostwide ;
run ;



/***** Save MINIMUM wide dataset TO STACK LATER with other projects */

DATA &Project..RedPrePostWideMin;
	set _redprepostwide ;
	*drop &prelist. &postlist. ;
	keep idvar cohort timestamp preseavg PostTimestamp Postseavg pre post project 
		prebeavg preevavg postbeavg postevavg ;
run ;

* LONG - Stack long (same varnames) ;
 Data _long ;
 	length prepost $4. ;
	set _RedPre2 _RedPost2 ;
	Project = "&Project." ;
run ;

* Only if there are pre and post ;
***** Save  long ***** ;
PROC SQL ; CREATE TABLE &Project..RedPrePostLong
	as select * 
	from _long
	where IDVAR in
		(SELECT IDVAR
			FROM _redprepostwide ) ;
quit ;


/* Clean up ;

PROC DATASETS lib=work ;
	delete  _: ;
run ;

*/
