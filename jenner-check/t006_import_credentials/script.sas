* Import credentials ;

DATA SE.Credentials ;
	infile datalines dsd delimiter=',' missover;
	length ID $12 Credential $8 IDvar $10 Credentialtxt $8;
	input ID $ Credential $ IDvar $ Credentialtxt $ Prescriber Medical Behavioral;
	datalines;
"adhd,P001",X,P001,MD,1,1,0
"adhd,P002",X,P002,RN,0,1,0
"adol,P004",X,P004,MD,1,1,0
;
run;


DATA se.credentials ;
	set se.credentials ;
	drop Credential IDvar ;
run ;


PROC SORT data=se.credentials ; by ID ; 
PROC SORT data=SE.prepostwide ; by ID ;

DATA SE.prepostcred ;
	merge se.credentials se.prepostwide ;
	by ID ; 
run ;
