* Make macro variables ;

/*

proc sql noprint;
	select variable
		into :CREDENTIAL 
		from Dict&Project. 
		where upcase(Detail) = "CREDENTIAL" ;

	select variable
		into :PastPart
		from Dict&Project. 
		where upcase(Detail) = "PASTPARTYN" ;

	select variable
		into :PracYears
		from Dict&Project. 
		where upcase(Detail) = "PRACYEARS" ;

		*0, Less than 2 years | 1, 2-5 | 2, 6-10 | 3, More than 10 ;
quit ;

	%put &CREDENTIAL ;
	%put &PastPart ;
	%put &PracYears ;

*/




* Create Pre/Post variable lists ;


**********************************************************************;
* Pre variable list ;
**********************************************************************;

	DATA PREdict ;
	SET work.dict&Project. ;
		where upcase(prepost) in ('PRE') ;
		_count = length(strip(Variable)) ;
		findi = _count-&PreNc. ;
		Var2 = substr(Variable,1,findi) ;
		keep Variable PrePost Var2 Domain Field_Label Theme ;
	run ;

* Count # domain variables for both PRE and POST for averages ;
	PROC SQL ; 
		SELECT COUNT(*) into :N_SE 
			FROM PREdict 
			WHERE Upcase(domain) = 'SE' ;
		SELECT COUNT(*) into :N_EV 
			FROM PREdict 
			WHERE upcase(domain) = 'EVALUATION' ;
		SELECT COUNT(*) into :N_BE
			FROM PREdict 
			WHERE upcase(domain) = 'BEHAVIOR' ;
	/* For BHPsy and SMI ;
		SELECT COUNT(*) into :N_S1
			FROM PREdict
			where upcase(domain) = 'SCALE1' ; */
	QUIT ;
	%put &N_SE ;
	%put &N_EV ;
*	%put &N_BE ;
*	%put &N_S1 ;

* Varlists for rename statement for long ;
	proc sql noprint;
	  select catt(variable,'=',var2)
	    into :Prenames separated by ' '
	    from PREdict ;
	quit;

	%put &Prenames ;

* Varlists PRE ;
	proc sql noprint;
	  select variable
	    into :PRESEc separated by ', '
	    from PREdict 
		where upcase(domain) = "SE" ;

	  select catt(variable,'=',Theme)
	    into :Theme separated by ' '
	    from Predict 
		where Theme is not null and upcase(domain) = "SE"  ;
*
	  select variable
	    into :PREBEc separated by ', '
	    from PREdict 
		where upcase(domain) = "BEHAVIOR" ;
	  select variable
	    into :PREEVc separated by ', '
	    from PREdict 
		where upcase(domain) = "EVALUATION" ;
	quit;

*	%put &Theme ;

	%put &PRESEc ;
*	%put &PREBEc ;
*	%put &PREEVc ;

* Macro variable Prelistc and Pre2listc (renamed) ;
	* c is for 'comma' ;
	PROC SQL noprint ;
		select  variable into :Prelistc
			separated by ', '
			from work.PREdict 
			order by var2;
		select  var2 into :Pre2listc
			separated by ', '
			from work.PREdict 
			order by var2;
		select  variable into :Prelist
			separated by ' '
			from work.PREdict 
			order by var2;
	QUIT ;

		%put &PreListc ;
		%put &Pre2listc ;
		%put &Prelist ;


**********************************************************************;
* Post variable list ;
**********************************************************************;

	DATA POSTdict ;
	SET work.dict&Project. ;
		where upcase(prepost) in ('POST') ;
		_count = length(strip(Variable)) ;
		findi = _count- &PostNc. ;
		Var2 = substr(Variable,1,findi) ;
		keep Variable PrePost Var2 Domain Theme ;
	run ;

* Varlists for rename statement for long ;
	proc sql noprint;
	  select catt(variable,'=',var2)
	    into :Postnames separated by ' '
	    from Postdict 
		where PrePost = 'Post';
	quit;

	%put &Postnames ;

* Varlists POST ;
	proc sql noprint;
	  select variable
	    into :POSTsec separated by ', '
	    from POSTdict 
		where upcase(domain) = "SE" ;
*	  select variable
	    into :POSTbec separated by ', '
	    from POSTdict 
		where upcase(domain) = "BEHAVIOR" ;
	  select variable
	    into :POSTEVc separated by ', '
	    from POSTdict 
		where upcase(domain) = "EVALUATION" ;
	quit;

	%put &POSTSEc ;
*	%put &POSTBEc ;
*	%put &POSTEVc ;


* Macro variable Postlisc and Post2list (renamed) ;
	PROC SQL noprint ;
		select  variable into :Postlistc
			separated by ', '
			from work.Postdict 
			where PrePost = 'Post'
			order by var2;
		select  var2 into :Post2listc
			separated by ', '
			from work.Postdict 
			where PrePost = 'Post'
			order by var2;
		select  variable into :Postlist
			separated by ' '
			from work.Postdict 
			where PrePost = 'Post'
			order by var2;
	QUIT ;

		%put &PostListc ;
		%put &Post2listc ;
		%put &PostList ;


* Paired variable names ;
	proc sort data=predict ; by var2 ;
	proc sort data=postdict ; by var2 ;
	DATA PairedDict ;
		merge predict (drop=prepost) postdict (rename=(variable=postvar) drop=prepost);
		by var2 ;
	run ;

data &Project..PairedDict ; 
	set PairedDict ; 
	Project = "&Project." ; 
	Project2 = "&Project." ; 

* There are two ADHD surveys, so Project2 brings them together ;
	if &Project in ("ADHDApr", "ADHDOct") then DO ;
		Project2 = "ADHD" ; 
	end ;

run ;

	proc sql noprint;
	  select catt(postvar,'*',variable)
	    into :PairedNames separated by '     '
	    from PairedDict  
		order by var2 ;
	quit;

	%put &PairedNames ;

	proc sql noprint;
	  select catt(postvar,'*',variable)
	    into :SEPairedNames separated by ' '
	    from PairedDict  
		where Domain = 'SE' 
		order by var2 ;
	quit;

	%put &SEPairedNames ;

	%put _global_ ;
