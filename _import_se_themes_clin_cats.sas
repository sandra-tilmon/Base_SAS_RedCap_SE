
   data se.THEMES    ;
    %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
    infile 'Z:\groups\ECHO-Chicago\Research\SE\SE questions_2020-07-27.csv' delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2 ;
       informat Project $10. ;
       informat Variable $7. ;
       informat var2 $5. ;
       informat Theme $65. ;
       informat Lesser_themes $19. ;
       informat CSDomain $20. ;
       informat CSComponent $39. ;
       informat Text $136. ;
       format Series $7. ;
       format Project $10. ;
       format var2 $5. ;
       format Theme $65. ;
       format Lesser_themes $19. ;
       format CSDomain $20. ;
       format CSComponent $39. ;
       format Text $136. ;
    input
                Project  $
                Variable  $
                var2  $
                Theme  $
                Lesser_themes  $
                CSDomain  $
                CSComponent  $
                Text  $
    ;
    if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
    run;

/*

	PROC IMPORT OUT= WORK.se_themes 
            DATAFILE= "Z:\groups\ECHO-Chicago\Research\SE\SE questions_2020-07-27.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
*/



