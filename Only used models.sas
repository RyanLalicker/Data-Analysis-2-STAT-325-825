FILENAME REFFILE '/home/u63984330/Data Analysis/data.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=data;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=data; RUN;
PROC print DATA=data;


/* Mixed Model*/
proc mixed data=data method=reml plots=(residualpanel);
    class treatment tissu dayPeriod campagne chamber;
    model StarchNscTissue = treatment|tissu|dayPeriod;
    lsmeans treatment dayPeriod tissu / pdiff=all cl adjust=tukey;
    random campagne chamber sample;
run;


/* Hierarchial Nested Model*/
proc mixed data=data method=reml plots=(residualpanel);
    class treatment tissu dayPeriod campagne chamber sample;
    model StarchNscTissue = treatment | tissu | dayPeriod;
    random campagne chamber(campagne) sample(chamber*campagne);
    lsmeans treatment tissu dayPeriod / pdiff=all cl adjust=tukey;
run;

/* GLMM Model */
proc glimmix data=data method=laplace plots=(residualpanel);
    class tissu treatment dayPeriod campagne sample chamber;
    model StarchNscTissue = tissu|treatment|dayPeriod / dist=gamma;
    random campagne sample chamber;
    lsmeans treatment dayPeriod tissu / pdiff=all cl adjust=tukey;
run;