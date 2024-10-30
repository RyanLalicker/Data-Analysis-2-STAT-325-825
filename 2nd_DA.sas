/* Generated Code (IMPORT) */
/* Source File: data-2.csv */
/* Source Path: /home/u63826292/825 */
/* Code generated on: 10/30/24, 4:16 PM */

%web_drop_table(WORK.IMPORT);


FILENAME REFFILE '/home/u63826292/825/data-2.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=data;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=data; RUN;


%web_open_table(WORK.IMPORT);
PROC CONTENTS DATA=data; RUN;
PROC print DATA=data;

%web_open_table(WORK.IMPORT);
/* Model 1*/
proc mixed data=data method=REML plots=(residualpanel);
    class tissu treatment dayPeriod campagne sample chamber;
    model StarchNscTissue = tissu|treatment|dayPeriod / solution;
    random campagne sample chamber;
run;

/* Mixed Model*/
proc mixed data=data method=reml plots=(residualpanel);
    class treatment tissu dayPeriod campagne chamber;
    model StarchNscTissue = treatment|tissu|dayPeriod;
    random campagne chamber sample;
    lsmeans treatment dayPeriod tissu / pdiff=all cl adjust=tukey;
run;
proc mixed data=data method=reml plots=(residualpanel);
    class treatment tissu dayPeriod campagne chamber;
    model StarchNscTissue = treatment|tissu|dayPeriod;
    random campagne chamber sample;

run;
/* Split Plot*/
proc mixed data=data plots=(residualpanel);
    class campagne treatment chamber dayPeriod tissu;
    model StarchNscTissue = treatment | dayPeriod | tissu / ddfm=kr;
    random sample campagne chamber(campagne) dayPeriod*chamber(campagne);
    lsmeans treatment dayPeriod tissu / pdiff=all cl adjust=tukey;
run;
/*Split Split Plot*/
proc mixed data=data plots=(residualpanel);
    class campagne treatment dayPeriod tissu time chamber;
    model StarchNscTissue = treatment | dayPeriod | tissu / ddfm=kr;
    random campagne treatment*campagne dayPeriod*treatment*campagne;
    lsmeans treatment dayPeriod tissu / pdiff=all cl adjust=tukey;
run;


/* Model 2: Nested Model for DayPeriod and Time Effects*/ 

proc mixed data=data method=REML plots=(residualpanel);
    class tissu treatment dayPeriod campagne sample chamber;
    model StarchNscTissue = tissu treatment dayPeriod / solution;
    random campagne sample chamber;
run;

/* Nested Structure with Dayperiod*/[not good]
proc mixed data=data plots=(residualpanel);
    class campagne treatment dayPeriod tissu time sample chamber;
    model StarchNscTissue = treatment | dayPeriod | tissu(time) / ddfm=kr;
    lsmeans treatment dayPeriod tissu(time) / pdiff=all cl adjust=tukey;
    random sample campagne chamber(campagne);   
run;

/* Hierarchial Nested Model*/

proc mixed data=data method=reml plots=(residualpanel);
    class treatment tissu dayPeriod campagne chamber sample;
    model StarchNscTissue = treatment | tissu | dayPeriod;
    random campagne chamber(campagne) sample(chamber*campagne);
    lsmeans treatment tissu dayPeriod / pdiff=all cl adjust=tukey;
run;

/* If I put chamber as fixed effect */
proc mixed data=data method=reml plots=(residualpanel);
    class treatment tissu dayPeriod campagne chamber sample;
    model StarchNscTissue = treatment | tissu | dayPeriod;
    random campagne sample(chamber*campagne);
    lsmeans treatment dayPeriod tissu / pdiff=all cl adjust=tukey;
run;

/* GLMM Model */
proc glimmix data=data method=laplace plots=(residualpanel);
    class tissu treatment dayPeriod campagne sample chamber;
    model StarchNscTissue = tissu|treatment|dayPeriod / dist=gamma;
    random campagne sample chamber;
    lsmeans treatment dayPeriod tissu / pdiff=all cl adjust=tukey;
run;

/* Crossed Random Effect*/
proc mixed data=data method=reml plots=(residualpanel);
    class treatment tissu dayPeriod campagne chamber time;
    model StarchNscTissue = treatment | tissu | dayPeriod;
    random campagne chamber time;
run;



