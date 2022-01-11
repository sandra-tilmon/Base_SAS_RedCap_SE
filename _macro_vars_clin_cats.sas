**********************************************************************
* Clinical skill categories macro varlists ;
*********************************************************************;

data _temp ;
	set se.'SE questions_2020_01_14'n ;
	where Series = "&Project." ;
run ;

	PROC SQL noprint ;
*** spaces ;
* CSDomain ;
		select  PreVar into :PreComm
			separated by ' '
			from _temp 
			where CSDomain = 'Communication skills';
		select  PreVar into :PreExam
			separated by ' '
			from _temp 
			where CSDomain = 'Examination skills';
		select  PreVar into :PreTreat
			separated by ' '
			from _temp 
			where CSDomain = 'Treatment skills';
		select  PostVar into :PostComm
			separated by ' '
			from _temp 
			where CSDomain = 'Communication skills';
		select  PostVar into :PostExam
			separated by ' '
			from _temp 
			where CSDomain = 'Examination skills';
		select  PostVar into :PostTreat
			separated by ' '
			from _temp 
			where CSDomain = 'Treatment skills';
* CSComponent ;
		select  PreVar into :PreClin
			separated by ' '
			from _temp 
			where CSComponent = 'Clinical reasoning';
		select  PreVar into :PreKnow
			separated by ' '
			from _temp 
			where CSComponent = 'Knowledge';
		select  PreVar into :PreProc
			separated by ' '
			from _temp 
			where CSComponent = 'Procedural';
		select  PostVar into :PostClin
			separated by ' '
			from _temp 
			where CSComponent = 'Clinical reasoning';
		select  PostVar into :PostKnow
			separated by ' '
			from _temp 
			where CSComponent = 'Knowledge';
		select  PostVar into :PostProc
			separated by ' '
			from _temp 
			where CSComponent = 'Procedural';


*** commas ;
* CSDomain ;
		select  PreVar into :PreCommc
			separated by ', '
			from _temp 
			where CSDomain = 'Communication skills';
		select  PreVar into :PreExamc
			separated by ', '
			from _temp 
			where CSDomain = 'Examination skills';
		select  PreVar into :PreTreatc
			separated by ', '
			from _temp 
			where CSDomain = 'Treatment skills';
		select  PostVar into :PostCommc
			separated by ', '
			from _temp 
			where CSDomain = 'Communication skills';
		select  PostVar into :PostExamc
			separated by ', '
			from _temp 
			where CSDomain = 'Examination skills';
		select  PostVar into :PostTreatc
			separated by ', '
			from _temp 
			where CSDomain = 'Treatment skills';

* CSComponent ;
		select  PreVar into :PreClinc
			separated by ', '
			from _temp 
			where CSComponent = 'Clinical reasoning';
		select  PreVar into :PreKnowc
			separated by ', '
			from _temp 
			where CSComponent = 'Knowledge';
		select  PreVar into :PreProcc
			separated by ', '
			from _temp 
			where CSComponent = 'Procedural';
		select  PostVar into :PostClinc
			separated by ', '
			from _temp 
			where CSComponent = 'Clinical reasoning';
		select  PostVar into :PostKnowc
			separated by ', '
			from _temp 
			where CSComponent = 'Knowledge';
		select  PostVar into :PostProcc
			separated by ', '
			from _temp 
			where CSComponent = 'Procedural';

	QUIT ;

	%put &PreComm. &PostComm. ;

	%put &PreExam. &PostExam. ;

	%put &PreTreat. &PostTreat. ;

	%put &PreProcc. &PostProcc. ;
