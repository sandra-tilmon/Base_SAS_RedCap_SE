* Import credentials ;

PROC IMPORT OUT= SE.Credentials 
            DATAFILE= "Z:\groups\ECHO-Chicago\Research\SE\CredentialsCat.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;


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
