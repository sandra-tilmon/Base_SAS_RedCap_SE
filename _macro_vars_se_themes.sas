***********************************************************
* Theme varlists ;
*********************************************************;

*%let Project = ADHDApr ;
*%let Project = ADHDOct ;
*%let Project = Adol ;
*%let Project = CAT ;
*%let Project = CPA ;
*%let Project = Obesity ;



	proc sql noprint ;
	  select catt(postvar,'-',variable)
	    into : Clinical&Project. separated by ' '
	    from &Project..PairedDict  
		where Theme like 'Clinical%' OR	Theme in 
			(
			'Diagnosis', 'Medication', 'Referrals', 'Screening',
				'Understand scope'
			) ;

		SELECT COUNT(*) into :N_Clinical&Project.  
		    from &Project..PairedDict  
			where Theme like 'Clinical%' OR	Theme in 
				(
				'Diagnosis', 'Medication', 'Referrals', 'Screening',
					'Understand scope'
				) ;

	  select catt(postvar,'-',variable)
	    into : Collab&Project. separated by ' '
	    from &Project..PairedDict  
		where Theme in 
			(
			'Collaboration', 'Educate staff', 'Lead QI efforts', 'Organizational change',
			'Serve as a SME', 'System-based practice'
			);

			
		SELECT COUNT(*) into :N_Collab&Project. 
		    from &Project..PairedDict  
			where Theme in 
				(
				'Collaboration', 'Educate staff', 'Lead QI efforts', 'Organizational change',
				'Serve as a SME', 'System-based practice'
				);

	  select catt(postvar,'-',variable)
	    into : EducMotiv&Project. separated by ' '
	    from &Project..PairedDict  
		where Theme in 
		(
		'Educate and motivate patients', 'Engaging caregivers', 'Legal planning'
		);

					
		SELECT COUNT(*) into :N_EducMotiv&Project.
		    from &Project..PairedDict  
			where Theme in 
			(
			'Educate and motivate patients', 'Engaging caregivers', 'Legal planning'
			);

	  select catt(postvar,'-',variable)
	    into : Community&Project. separated by ' '
	    from &Project..PairedDict  
		where Theme in 
		(
		'Resources', 'SDOH'
		);

		SELECT COUNT(*) into :N_Community&Project.
		    from &Project..PairedDict  
			where Theme in 
			(
			'Resources', 'SDOH'
			);

	quit ;

	%put &&Clinical&Project. ;
	%put &&Collab&Project. ;
	%put &&EducMotiv&Project. ;
	%put &&Community&Project. ;

	
	%put &&N_Clinical&Project. ;	
	%put &&N_Collab&Project. ;
	%put &&N_EducMotiv&Project. ;
	%put &&N_Community&Project. ;
