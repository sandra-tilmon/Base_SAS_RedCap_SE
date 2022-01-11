

DATA se.stacked ;
	set adhdapr.se_themes 
		adhdoct.se_themes
		adol.se_themes
		cpa.se_themes
		cat.se_themes
		diabetes.se_themes
		geri.se_themes
		gerisnf.se_themes
		hcv.se_themes
		htn.se_themes
		obesity.se_themes
		opiates.se_themes
		rbwh.se_themes
		smi.se_themes
	;

	project2 = project ;
	if project in ('adhdapr', 'adhdoct') then project2 = 'adhd' ;
	
	id = catx(',', Project2, idvar) ;
run ;

proc freq data=se.stacked ;
	tables project2 theme / list missing ;
run ;





data pre ;
	set se.stacked ;
	if PrePost = 'Pre' ;
	pre = answer ;
	drop answer ;
run ;

data post ;
	set se.stacked ;
	if PrePost = 'Post' ;
	post = answer ;
	keep ID post ;
run ;



proc sort data=pre ; by ID ; proc sort data=post ; by ID ; run ;

DATA SE.prepostwide ;
	merge pre (in=_pre) post (in=_post) ;
	by ID ;
	if _pre and _post ;
	if theme = 'Clinical skill - sensitive -' then theme = 'Clinical skill - sensitive' ;
	delta = Post - Pre ;
run ;

